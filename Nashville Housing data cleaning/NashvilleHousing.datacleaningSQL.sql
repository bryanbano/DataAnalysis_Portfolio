Select *
From SQLProject2.dbo.NashvilleHousingData


--Standardize Date Format

Select SaleDateConverted, Convert(Date,SaleDate)
From SQLProject2.dbo.NashvilleHousingData

Alter Table NashvilleHousingData
Add SaleDateConverted Date;

Update NashvilleHousingData
Set SaleDateConverted = Convert(Date,SaleDate)


--Populate Property Address data

Select *
From SQLProject2.dbo.NashvilleHousingData
--Where PropertyAddress is null
Order by ParcelID
--ParcelID that are the same have the same PropertyAddress

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From SQLProject2.dbo.NashvilleHousingData a
Join SQLProject2.dbo.NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From SQLProject2.dbo.NashvilleHousingData a
Join SQLProject2.dbo.NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out Address into individual columns (Address, City, State)
--First PropertyAddress
Select PropertyAddress
From SQLProject2.dbo.NashvilleHousingData

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From SQLProject2.dbo.NashvilleHousingData

Alter Table NashvilleHousingData
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousingData
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table NashvilleHousingData
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousingData
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From SQLProject2.dbo.NashvilleHousingData

--Next OwnerAddress

Select OwnerAddress
From SQLProject2.dbo.NashvilleHousingData

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From SQLProject2.dbo.NashvilleHousingData


Alter Table NashvilleHousingData
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousingData
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Alter Table NashvilleHousingData
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousingData
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Alter Table NashvilleHousingData
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousingData
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


--Change Y and N to Yes and No in SoldAsVacant 

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From SQLProject2.dbo.NashvilleHousingData
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
From SQLProject2.dbo.NashvilleHousingData

Update NashvilleHousingData
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END


--Remove Duplicates

With RowNumCTE AS(

Select *,
	ROW_NUMBER() OVER (
	Partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY UniqueID
) row_num
From SQLProject2.dbo.NashvilleHousingData
)

DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



--Delete Unused Columns

Alter Table SQLProject2.dbo.NashvilleHousingData
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Select *
From SQLProject2.dbo.NashvilleHousingData

Alter Table SQLProject2.dbo.NashvilleHousingData
Drop Column SaleDate