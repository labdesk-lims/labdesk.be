CREATE VIEW dbo.view_measurement
AS
SELECT dbo.measurement.id, dbo.measurement.request, dbo.customer.name AS customer, dbo.analysis.title AS analysis, dbo.method.title AS method, dbo.instrument.title AS instrument, dbo.measurement.value_txt AS value, dbo.audit_get_value('analysis', dbo.analysis.id, 'unit', dbo.measurement.acquired_at) AS unit, dbo.measurement.out_of_spec, dbo.measurement.state, 
         dbo.request.profile, dbo.measurement.subcontraction
FROM  dbo.state INNER JOIN
         dbo.request ON dbo.state.id = dbo.request.state INNER JOIN
         dbo.customer ON dbo.request.customer = dbo.customer.id INNER JOIN
         dbo.measurement ON dbo.request.id = dbo.measurement.request LEFT OUTER JOIN
         dbo.analysis ON dbo.measurement.analysis = dbo.analysis.id LEFT OUTER JOIN
         dbo.instrument ON dbo.measurement.instrument = dbo.instrument.id LEFT OUTER JOIN
         dbo.method ON dbo.measurement.method = dbo.method.id
WHERE (dbo.measurement.state = 'CP') AND (dbo.state.state = 'RC') OR
         (dbo.measurement.state = 'AQ')

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[54] 4[23] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "state"
            Begin Extent = 
               Top = 365
               Left = 994
               Bottom = 495
               Right = 1164
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "request"
            Begin Extent = 
               Top = 264
               Left = 679
               Bottom = 394
               Right = 861
            End
            DisplayFlags = 280
            TopColumn = 18
         End
         Begin Table = "customer"
            Begin Extent = 
               Top = 147
               Left = 996
               Bottom = 277
               Right = 1166
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "measurement"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 346
               Right = 381
            End
            DisplayFlags = 280
            TopColumn = 16
         End
         Begin Table = "analysis"
            Begin Extent = 
               Top = 449
               Left = 570
               Bottom = 579
               Right = 765
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "instrument"
            Begin Extent = 
               Top = 747
               Left = 340
               Bottom = 877
               Right = 515
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "method"
            Begin Extent = 
               Top = 584
               Left = 437
               Bottom = 713
               Right = 607
            End
            Displ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_measurement';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'ayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1575
         Alias = 2220
         Table = 2805
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_measurement';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_measurement';

