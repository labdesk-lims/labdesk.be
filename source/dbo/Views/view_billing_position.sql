CREATE VIEW dbo.view_billing_position
AS
SELECT        dbo.billing_position.id, dbo.billing_position.category, CONVERT(int, ISNULL(CONVERT(varchar(255), dbo.method.id), '') + ISNULL(CONVERT(varchar(255), dbo.service.id), '') + ISNULL(CONVERT(varchar(255), dbo.analysis.id), '') 
                         + ISNULL(CONVERT(varchar(255), dbo.material.id), '') + ISNULL(CONVERT(varchar(255), dbo.profile.id), '')) AS article_no, ISNULL(dbo.billing_position.other, '') + ISNULL(dbo.method.title, '') + ISNULL(dbo.analysis.title, '') 
                         + ISNULL(dbo.material.title, '') + ISNULL(dbo.service.title, '') + ISNULL(dbo.profile.title, '') AS description, dbo.billing_position.amount, dbo.billing_position.price, 
                         dbo.billing_position.amount * dbo.billing_position.price AS extended_price, dbo.billing_position.billing_customer
FROM            dbo.billing_position LEFT OUTER JOIN
                         dbo.profile ON dbo.billing_position.profile = dbo.profile.id LEFT OUTER JOIN
                         dbo.material ON dbo.billing_position.material = dbo.material.id LEFT OUTER JOIN
                         dbo.analysis ON dbo.billing_position.analysis = dbo.analysis.id LEFT OUTER JOIN
                         dbo.service ON dbo.billing_position.service = dbo.service.id LEFT OUTER JOIN
                         dbo.method ON dbo.billing_position.method = dbo.method.id

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[45] 4[24] 2[14] 3) )"
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
         Begin Table = "billing_position"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "profile"
            Begin Extent = 
               Top = 638
               Left = 433
               Bottom = 768
               Right = 619
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "material"
            Begin Extent = 
               Top = 489
               Left = 436
               Bottom = 619
               Right = 632
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "analysis"
            Begin Extent = 
               Top = 347
               Left = 437
               Bottom = 475
               Right = 632
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "service"
            Begin Extent = 
               Top = 200
               Left = 436
               Bottom = 330
               Right = 633
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "method"
            Begin Extent = 
               Top = 60
               Left = 436
               Bottom = 190
               Right = 633
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width =', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_billing_position';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N' 1815
         Width = 2040
         Width = 3105
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 19005
         Alias = 4290
         Table = 5085
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_billing_position';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'view_billing_position';

