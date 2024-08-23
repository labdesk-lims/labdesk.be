-- =============================================
-- Author:		Kogel, Lutz
-- Create date: 2022 March
-- Description:	GESD test
-- =============================================
CREATE PROCEDURE [dbo].[gesd_test]
	-- Add the parameters for the stored procedure here
	@inquery nvarchar(max),
	@alpha float,
	@max_outliers int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @s nvarchar(max)

	SET @s =

N'
from scipy import stats
import pandas as pd
import numpy as np

def esd_test(df, max_outliers, alpha):
	""" Perform GESD test
	Parameters
	----------
	df : DataFrame
		DataFrame to calculate GESD from
	max_outliers : int
		Maximum outliers for GESD calculation
	alpha : float
		Alpha error of t-distribution
	"""
	ind = list(InputDataSet["id"])
	x = list(df.values)
	outliers = []
	res_lst = [] # ESD Test Statistic for each k anomaly
	lam_lst = [] # Critical Value for each k anomaly
	n = len(x)
		
	if max_outliers is None:
		max_outliers = len(x)
		
	for i in range(1,max_outliers+1):
		x_mean = np.mean(x)
		x_std = np.std(x,ddof=1)
		res = abs((x - x_mean) / x_std)
		max_res = np.max(res)
		max_ind = np.argmax(res)
		p = 1 - alpha / (2*(n-i+1))
		t_v = stats.t.ppf(p,(n-i-1)) # Get critical values from t-distribution based on p and n
		lam_i = ((n-i)*t_v)/ np.sqrt((n-i-1+t_v**2)*(n-i+1)) # Calculate critical region (lambdas)
		res_lst.append(max_res)
		lam_lst.append(lam_i)
		if max_res > lam_i:
			outliers.append((ind.pop(max_ind),x.pop(max_ind)))
				
	# Record outlier Points
	outliers_index = [x[0] for x in outliers]
	return outliers_index

OutputDataSet = pd.DataFrame(esd_test(InputDataSet["value"], ' + CAST(@max_outliers As nvarchar) + ', ' + CAST(@alpha As nvarchar) + '));
'

	EXECUTE sp_execute_external_script @language = N'Python', @script = @s, @input_data_1 = @inquery
END
