-----data cleaning in sql 

select * from Nationalhousing 

---- standardize date format 

alter table nationalhousing
alter column  saledate date 

select saledate from nationalhousing

select * from nationalhousing 

---- populate property address data 

select * from nationalhousing where propertyaddress is null 

select parcelid,propertyaddress from nationalhousing 

select distinct(x.parcelid),x.propertyaddress,y.parcelid,y.propertyaddress,
isnull(x.propertyaddress,y.propertyaddress)
from nationalhousing x join nationalhousing Y 
on x.parcelid = Y.parcelid and x.uniqueid <>y.uniqueid 
where x.propertyaddress is null 

update x 
set  x.propertyaddress =  isnull(x.propertyaddress,y.propertyaddress)
where x.propertyaddress is null  

----- breakking out adress into (address,city , state ) 

select  *  from nationalhousing

---substring,charindex 

select substring(propertyaddress,1,charindex(',',propertyaddress,1)-1) as city 
,substring(propertyaddress,charindex(',',propertyaddress,1)+1,len(propertyaddress)) as state 
from nationalhousing

alter table nationalhousing 
add address nvarchar(257) 

--- to change any column name 
sp_rename 'nationalhousing.state','city'

update nationalhousing
set address = substring(propertyaddress,1,charindex(',',propertyaddress,1)-1)

alter table nationalhousing 
add city   nvarchar(257)  

update nationalhousing
set city  = substring(propertyaddress,charindex(',',propertyaddress,1)+1,len(propertyaddress))

select owneraddress from nationalhousing  

select substring(owneraddress,charindex(',',propertyaddress,1)+1,) from nationalhousing 
 
 update nationalhousing set owneraddress = replace(owneraddress,',','.') 

select parsename(owneraddress,3) from nationalhousing  
select parsename(owneraddress,2) from nationalhousing
select parsename(owneraddress,1) from nationalhousing

alter table nationalhousing 
add ownersplitaddress   nvarchar(257)  

update nationalhousing
set ownersplitaddress = substring(owneraddress,1,charindex(',',propertyaddress,1)-1)


alter table nationalhousing 
add ownersplitcity   nvarchar(257)  

update nationalhousing
set ownersplitcity  = parsename(owneraddress,2)

alter table nationalhousing 
add ownersplitstate   nvarchar(257)  

select owneraddress from nationalhousing

update nationalhousing
set ownersplitstate  =  parsename(owneraddress,1)  

  ---- to view the columns 

  sp_help nationalhousing 

--------- change y and n to yes and no in sold as vacant field 
select * from nationalhousing 
update nationalhousing 
 set soldasvacant = replace(soldasvacant,'y','yes')

 update nationalhousing 
 set soldasvacant = replace(soldasvacant,'n','n0')
 ---otherway

select soldasvacant , case soldasvacant
                   when 'y' then'yes'
				   when 'n' then 'no'
				   else 'soldasvacant'
				   end 
 from nationalhousing 

 update  nationalhousing set soldasvacant =  case soldasvacant
                   when 'y' then'yes'
				   when 'n' then 'no'
				   else 'soldasvacant'
				   end 

------ remove duplicates ----

 with e as (select * ,row_number() over (partition by parcelid,propertyaddress,saledate,
                saleprice,legalreference order by uniqueid ) as rno 
				from nationalhousing)
delete from  e where rno >1

-----deleted unsual rows ---

alter table Nationalhousing
drop column propertyaddress,owneraddress,taxdistrict

alter table Nationalhousing
drop column saledate

 select * from Nationalhousing


                        






