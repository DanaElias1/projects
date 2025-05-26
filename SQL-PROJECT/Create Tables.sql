--SalesOrderDetail
CREATE TABLE [SalesOrderDetail](
	[SalesOrderID] [int] NOT NULL,
	[SalesOrderDetailID] [int] IDENTITY(1,1) NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[OrderQty] [smallint] NOT NULL,
	[ProductID] [int] NOT NULL,
	[SpecialOfferID] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[UnitPriceDiscount] [money] NOT NULL,
	[LineTotal]  AS (isnull(([UnitPrice]*((1.0)-[UnitPriceDiscount]))*[OrderQty],(0.0))),
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID] PRIMARY KEY CLUSTERED 
(
	[SalesOrderID] ASC,
	[SalesOrderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [SalesOrderDetail] ADD  CONSTRAINT [DF_SalesOrderDetail_UnitPriceDiscount]  DEFAULT ((0.0)) FOR [UnitPriceDiscount]
GO

INSERT [SalesOrderDetail]([SalesOrderID], [CarrierTrackingNumber], [OrderQty], [ProductID], [SpecialOfferID],
[UnitPrice], [UnitPriceDiscount], [rowguid], [ModifiedDate])
SELECT [SalesOrderID], [CarrierTrackingNumber], [OrderQty], [ProductID], [SpecialOfferID],
[UnitPrice], [UnitPriceDiscount], [rowguid], [ModifiedDate] FROM [SalesOrderDetail]

--SalesOrderHeader
CREATE TABLE [SalesOrderHeader](
	[SalesOrderID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[ShipDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL,
	[OnlineOrderFlag] BIT NOT NULL,
	[SalesOrderNumber]  AS (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID]),N'*** ERROR ***')),
	[PurchaseOrderNumber] Nvarchar(25) NULL,
	[AccountNumber] Nvarchar(15)  NULL,
	[CustomerID] [int] NOT NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[BillToAddressID] [int] NOT NULL,
	[ShipToAddressID] [int] NOT NULL,
	[ShipMethodID] [int] NOT NULL,
	[CreditCardID] [int] NULL,
	[CreditCardApprovalCode] [varchar](15) NULL,
	[CurrencyRateID] [int] NULL,
	[SubTotal] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
 CONSTRAINT [PK_SalesOrderHeader_SalesOrderID] PRIMARY KEY CLUSTERED 
(
	[SalesOrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [SalesOrderHeader] ADD  CONSTRAINT [DF_SalesOrderHeader_RevisionNumber]  DEFAULT ((0)) FOR [RevisionNumber]
GO

INSERT [SalesOrderHeader]([RevisionNumber], [OrderDate], [DueDate], [ShipDate], [Status], [OnlineOrderFlag], 
[PurchaseOrderNumber], [AccountNumber], [CustomerID], [SalesPersonID], [TerritoryID],
[BillToAddressID], [ShipToAddressID], [ShipMethodID], [CreditCardID], [CreditCardApprovalCode], [CurrencyRateID],
[SubTotal], [TaxAmt], [Freight])
SELECT [RevisionNumber], [OrderDate], [DueDate], [ShipDate], [Status], [OnlineOrderFlag], 
[PurchaseOrderNumber], [AccountNumber], [CustomerID], [SalesPersonID], [TerritoryID],
[BillToAddressID], [ShipToAddressID], [ShipMethodID], [CreditCardID], [CreditCardApprovalCode], [CurrencyRateID],
[SubTotal], [TaxAmt], [Freight] FROM [SalesOrderHeader]

--Address
CREATE TABLE [Address](
	[AddressID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AddressLine1] [nvarchar](60) NOT NULL,
	[AddressLine2] [nvarchar](60) NULL,
	[City] [nvarchar](30) NOT NULL,
	[StateProvinceID] [int] NOT NULL,
	[PostalCode] [nvarchar](15) NOT NULL,
	[SpatialLocation] [geography] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Address_AddressID] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Address] ADD  CONSTRAINT [DF_Address_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

INSERT [Address]([AddressLine1], [AddressLine2], [City], [StateProvinceID], [PostalCode], [SpatialLocation],
[rowguid], [ModifiedDate])
SELECT [AddressLine1], [AddressLine2], [City], [StateProvinceID], [PostalCode], [SpatialLocation],
[rowguid], [ModifiedDate] FROM [Address]

--ShipMethod
CREATE TABLE [ShipMethod](
[ShipMethodID] [int] IDENTITY(1,1) NOT NULL,
[Name] nvarchar(50) NOT NULL,
[ShipBase] [money] NOT NULL,
[ShipRate] [money] NOT NULL,
[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ShipMethod_ShipMethodID] PRIMARY KEY CLUSTERED
(
[ShipMethodID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY =
OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,
OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [ShipMethod] ADD  CONSTRAINT [DF_ShipMethod_ShipBase]
DEFAULT ((0.00)) FOR [ShipBase]
GO
 
INSERT [ShipMethod]([Name] ,[ShipBase], [ShipRate], [rowguid], [ModifiedDate])
SELECT [Name] ,[ShipBase], [ShipRate], [rowguid], [ModifiedDate] FROM [ShipMethod]

--CurrencyRate
CREATE TABLE [CurrencyRate](
	[CurrencyRateID] [int] IDENTITY(1,1) NOT NULL,
	[CurrencyRateDate] [datetime] NOT NULL,
	[FromCurrencyCode] [nchar](3) NOT NULL,
	[ToCurrencyCode] [nchar](3) NOT NULL,
	[AverageRate] [money] NOT NULL,
	[EndOfDayRate] [money] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CurrencyRate_CurrencyRateID] PRIMARY KEY CLUSTERED 
(
	[CurrencyRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [CurrencyRate] ADD  CONSTRAINT [DF_CurrencyRate_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

INSERT [CurrencyRate]([CurrencyRateDate], [FromCurrencyCode], [ToCurrencyCode], [AverageRate], [EndOfDayRate],
[ModifiedDate])
SELECT [CurrencyRateDate], [FromCurrencyCode], [ToCurrencyCode], [AverageRate], [EndOfDayRate],
[ModifiedDate] FROM [CurrencyRate] 

--SpecialOfferProduct
CREATE TABLE [SpecialOfferProduct](
[SpecialOfferID] [int] NOT NULL,
[ProductID] [int] NOT NULL,
[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SpecialOfferProduct_SpecialOfferID_ProductID] PRIMARY
KEY CLUSTERED
(
[SpecialOfferID] ASC,
[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY =
OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,
OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [SpecialOfferProduct] ADD  CONSTRAINT
[DF_SpecialOfferProduct_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

INSERT [SpecialOfferProduct]
([SpecialOfferID],[ProductID],[rowguid],[ModifiedDate])
SELECT [SpecialOfferID],[ProductID],[rowguid],[ModifiedDate] FROM
[SpecialOfferProduct]

--CreditCard
CREATE TABLE [CreditCard](
	[CreditCardID] [int] IDENTITY(1,1) NOT NULL,
	[CardType] [nvarchar](50) NOT NULL,
	[CardNumber] [nvarchar](25) NOT NULL,
	[ExpMonth] [tinyint] NOT NULL,
	[ExpYear] [smallint] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CreditCard_CreditCardID] PRIMARY KEY CLUSTERED 
(
	[CreditCardID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [CreditCard] ADD  CONSTRAINT [DF_CreditCard_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO

INSERT [CreditCard]([CardType], [CardNumber], [ExpMonth], [ExpYear], [ModifiedDate])
SELECT [CardType], [CardNumber], [ExpMonth], [ExpYear], [ModifiedDate] FROM [CreditCard]

--BusinessEntity
CREATE TABLE [BusinessEntity](
[BusinessEntityID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_BusinessEntity_BusinessEntityID] PRIMARY KEY CLUSTERED
(
[BusinessEntityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY =
OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,
OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [BusinessEntity] ADD  CONSTRAINT
[DF_BusinessEntity_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

INSERT [BusinessEntity] ([rowguid],[ModifiedDate])
SELECT [rowguid],[ModifiedDate] FROM [BusinessEntity]

--SalesTerritory
CREATE TABLE [SalesTerritory](
[TerritoryID] [int] IDENTITY(1,1) NOT NULL,
[Name] [nvarchar](50) NOT NULL,
[CountryRegionCode] [nvarchar](3) NOT NULL,
[Group] [nvarchar](50) NOT NULL,
[SalesYTD] [money] NOT NULL,
[SalesLastYear] [money] NOT NULL,
[CostYTD] [money] NOT NULL,
[CostLastYear] [money] NOT NULL,
[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SalesTerritory_TerritoryID] PRIMARY KEY CLUSTERED
(
[TerritoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [SalesTerritory] ADD  CONSTRAINT [DF_SalesTerritory_SalesYTD]  DEFAULT ((0.00)) FOR [SalesYTD]
GO

INSERT [SalesTerritory]([Name], [CountryRegionCode], [Group], [SalesYTD], [SalesLastYear], [CostYTD] , [CostLastYear],
[rowguid], [ModifiedDate])
SELECT [Name], [CountryRegionCode], [Group], [SalesYTD], [SalesLastYear], [CostYTD] , [CostLastYear],
[rowguid], [ModifiedDate] FROM [SalesTerritory]

--Customer
CREATE TABLE [Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PersonID] [int] NULL,
	[StoreID] [int] NULL,
	[TerritoryID] [int] NULL,
	[AccountNumber]  AS (isnull('AW'+[dbo].[ufnLeadingZeros]([CustomerID]),'')),
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Customer] ADD  CONSTRAINT [DF_Customer_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

INSERT [Customer]([PersonID], [StoreID], [TerritoryID], [rowguid], [ModifiedDate]) 
SELECT [PersonID], [StoreID], [TerritoryID], [rowguid], [ModifiedDate] FROM [Customer]

--Product
CREATE TABLE [Product](
[ProductID] [int] IDENTITY(1,1) NOT NULL,
[Name] [nvarchar](50) NOT NULL,
[ProductNumber] [nvarchar](25) NOT NULL,
[MakeFlag] bit NOT NULL,
[FinishedGoodsFlag] bit NOT NULL,
[Color] [nvarchar](15) NULL,
[SafetyStockLevel] [smallint] NOT NULL,
[ReorderPoint] [smallint] NOT NULL,
[StandardCost] [money] NOT NULL,
[ListPrice] [money] NOT NULL,
[Size] [nvarchar](5) NULL,
[SizeUnitMeasureCode] [nchar](3) NULL,
[WeightUnitMeasureCode] [nchar](3) NULL,
[Weight] [decimal](8, 2) NULL,
[DaysToManufacture] [int] NOT NULL,
[ProductLine] [nchar](2) NULL,
[Class] [nchar](2) NULL,
[Style] [nchar](2) NULL,
[ProductSubcategoryID] [int] NULL,
[ProductModelID] [int] NULL,
[SellStartDate] [datetime] NOT NULL,
[SellEndDate] [datetime] NULL,
[DiscontinuedDate] [datetime] NULL,
[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Product_ProductID] PRIMARY KEY CLUSTERED
(
[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY =
OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,
OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [Product] ADD  CONSTRAINT [DF_Product_MakeFlag]  DEFAULT
((1)) FOR [MakeFlag]
GO

INSERT [Product](PRODUCTID, [Name], [ProductNumber], [MakeFlag],
[FinishedGoodsFlag], [Color], [SafetyStockLevel], [ReorderPoint],
[StandardCost], [ListPrice], [Size], [SizeUnitMeasureCode],
[WeightUnitMeasureCode], [Weight], [DaysToManufacture],
[ProductLine], [Class], [Style], [ProductSubcategoryID],
[ProductModelID], [SellStartDate], [SellEndDate],
[DiscontinuedDate], [rowguid], [ModifiedDate])
SELECT PRODUCTID,[Name], [ProductNumber], [MakeFlag],
[FinishedGoodsFlag], [Color], [SafetyStockLevel], [ReorderPoint],
[StandardCost], [ListPrice], [Size], [SizeUnitMeasureCode],
[WeightUnitMeasureCode], [Weight], [DaysToManufacture],
[ProductLine], [Class], [Style], [ProductSubcategoryID],
[ProductModelID], [SellStartDate], [SellEndDate],
[DiscontinuedDate], [rowguid], [ModifiedDate] FROM [Product]

--ProductCategory
CREATE TABLE [ProductCategory](
[ProductCategoryID] [int] IDENTITY(1,1) NOT NULL,
[Name] NVARCHAR (50) NOT NULL,
[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProductCategory_ProductCategoryID] PRIMARY KEY CLUSTERED
(
[ProductCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY =
OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,
OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [ProductCategory] ADD  CONSTRAINT
[DF_ProductCategory_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

INSERT [ProductCategory] ([Name],[rowguid],[ModifiedDate])
SELECT [Name],[rowguid],[ModifiedDate] FROM [ProductCategory]

--ProductSubcategory
CREATE TABLE [ProductSubcategory](
[ProductSubcategoryID] [int] IDENTITY(1,1) NOT NULL,
[ProductCategoryID] [int] NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProductSubcategory_ProductSubcategoryID] PRIMARY KEY CLUSTERED
(
[ProductSubcategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [ProductSubcategory] ADD  CONSTRAINT [DF_ProductSubcategory_rowguid]  DEFAULT (newid()) FOR [rowguid]
GO

INSERT [ProductSubcategory]([ProductCategoryID], [Name], [rowguid], [ModifiedDate])
SELECT [ProductCategoryID], [Name], [rowguid], [ModifiedDate] FROM [ProductSubcategory]

--Person
CREATE TABLE [Person](
	[BusinessEntityID] [int] NOT NULL,
	[PersonType] [nchar](2) NOT NULL,
	[NameStyle] bit NOT NULL,
	[Title] [nvarchar](8) NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Suffix] [nvarchar](10) NULL,
	[EmailPromotion] [int] NOT NULL,
	[AdditionalContactInfo] [xml] NULL,
	[Demographics] [xml] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Person_BusinessEntityID] PRIMARY KEY CLUSTERED 
(
	[BusinessEntityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Person] ADD  CONSTRAINT [DF_Person_NameStyle]  DEFAULT ((0)) FOR [NameStyle]
GO

INSERT [Person]([BusinessEntityID], [PersonType], [NameStyle], [Title], [FirstName], [MiddleName], [LastName],
[Suffix], [EmailPromotion], [Demographics], [rowguid], [ModifiedDate])
SELECT [BusinessEntityID], [PersonType], [NameStyle], [Title], [FirstName], [MiddleName], [LastName],
[Suffix], [EmailPromotion], [Demographics], [rowguid], [ModifiedDate] FROM [Person]

--SalesPerson
CREATE TABLE [SalesPerson](
[BusinessEntityID] [int] NOT NULL,
[TerritoryID] [int] NULL,
[SalesQuota] [money] NULL,
[Bonus] [money] NOT NULL,
[CommissionPct] [smallmoney] NOT NULL,
[SalesYTD] [money] NOT NULL,
[SalesLastYear] [money] NOT NULL,
[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SalesPerson_BusinessEntityID] PRIMARY KEY CLUSTERED
(
[BusinessEntityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY =
OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON,
OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [SalesPerson] ADD  CONSTRAINT [DF_SalesPerson_Bonus]
DEFAULT ((0.00)) FOR [Bonus]
GO

INSERT [SalesPerson]([BusinessEntityID],[TerritoryID],[SalesQuota],[Bonus],[CommissionPct],[SalesYTD],[SalesLastYear]
,[rowguid],[ModifiedDate])
SELECT [BusinessEntityID],[TerritoryID],[SalesQuota],[Bonus],[CommissionPct],[SalesYTD],[SalesLastYear]
,[rowguid],[ModifiedDate] FROM [SalesPerson]

--Department
CREATE TABLE [Department](
[DepartmentID] [smallint] IDENTITY(1,1) NOT NULL,
[Name] nvarchar(50) NOT NULL,
[GroupName] nvarchar(50) NOT NULL,
[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Department_DepartmentID] PRIMARY KEY CLUSTERED
(
[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
