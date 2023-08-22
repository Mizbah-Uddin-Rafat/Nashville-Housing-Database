/*
    Clearing Data
*/

Select *
From  Nashvillehousing.dbo.Nashvillehousing

--Standerize data formet

Select Saledate, Convert(Date,SaleDate) as SALEDATECONVERTED
From Nashvillehousing.dbo.Nashvillehousing

Update Nashvillehousing.dbo.Nashvillehousing
Set SaleDate = Convert(Date,SaleDate) 

--Populate Property Address data

Select *
From Nashvillehousing.dbo.Nashvillehousing
--where PropertyAddress is null
order by ParcelID


Select nully.ParcelID, addy.ParcelID, nully.PropertyAddress, addy.propertyaddress, ISNULL( nully.PropertyAddress,addy.propertyaddress)
From Nashvillehousing.dbo.Nashvillehousing nully
Join Nashvillehousing.dbo.Nashvillehousing addy
ON nully.ParcelID = addy.ParcelID
AND nully.[UniqueID ] <> addy.[UniqueID ]
Where nully.PropertyAddress is null

Update nully
Set Propertyaddress = ISNULL( nully.PropertyAddress,addy.propertyaddress)
From Nashvillehousing.dbo.Nashvillehousing nully
Join Nashvillehousing.dbo.Nashvillehousing addy
ON nully.ParcelID = addy.ParcelID
AND nully.[UniqueID ] <> addy.[UniqueID ]
Where nully.PropertyAddress is null

--Breakingout adress into individual columns (Address, City, STATE)

Select Propertyaddress
From Nashvillehousing.dbo.Nashvillehousing
--where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From Nashvillehousing.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From Nashvillehousing.dbo.NashvilleHousing

Select OwnerAddress
From Nashvillehousing.dbo.NashvilleHousing

Select
PARSENAME (Replace(OwnerAddress, ',','.'),3),
PARSENAME (Replace(OwnerAddress, ',','.'),2),
PARSENAME (Replace(OwnerAddress, ',','.'),1)
From Nashvillehousing.dbo.NashvilleHousing

ALTER TABLE Nashvillehousing.dbo.NashvilleHousing
Add OwmerSplitAddress Nvarchar(255);

Update Nashvillehousing.dbo.NashvilleHousing
SET OwmerSplitAddress = PARSENAME(Replace(OwnerAddress, ',','.'),3)

ALTER TABLE Nashvillehousing.dbo.NashvilleHousing
Add OwmerSplitCity Nvarchar(255);

Update Nashvillehousing.dbo.NashvilleHousing
SET OwmerSplitCity = PARSENAME(Replace(OwnerAddress, ',','.'),2)

ALTER TABLE Nashvillehousing.dbo.NashvilleHousing
Add OwmerSplitState Nvarchar(255);

Update Nashvillehousing.dbo.NashvilleHousing
SET OwmerSplitState = PARSENAME(Replace(OwnerAddress, ',','.'),1)


Select *
From Nashvillehousing.dbo.NashvilleHousing

--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Nashvillehousing.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant, 
Case When SoldAsVacant = 'Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
End
From Nashvillehousing.dbo.NashvilleHousing

Update Nashvillehousing.dbo.NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
When SoldAsVacant = 'N' Then 'No'
Else SoldAsVacant
End

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Nashvillehousing.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

--REMOVE DUPLICATES

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Nashvillehousing.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Nashvillehousing.dbo.NashvilleHousing



--Delete Unused Columns

Select *
From Nashvillehousing.dbo.NashvilleHousing


ALTER TABLE Nashvillehousing.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate