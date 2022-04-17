-- SQL'de çalıştıracağımız T-SQL sorgusunu seçip "Execute" ediyoruz. Yada "F5" tuşuna basıyoruz.
use Northwind

--Products tablosunun bütün kayıtlarını getirdik
select * from Products -- "*" sembolü bütün sütunları getir demek.

--Prodcuts tablosundan "Id", "ProdcutName", "CategoryId", "UnitPrice" ve "UnitInStock" bilgilerini getirin.
select ProductID, 
	   ProductName, 
	   CategoryID, 
	   UnitPrice, 
	   UnitsInStock 
from Products

--Categories tablosundan Id, CategoryName, Desciption bilgilerini getirin
select CategoryID,
	   CategoryName, 
	   Description 
	   from Categories


-- Where: Sorgu sonucunda bize dönen veri kümesi üzerinde filtreleme işlmeleri yapmak istediğimizde kullandığımız yapıdır.

--UnitPrice'sı 20 ile 60 arasında olan ürünlerin Id, Name, UnitPrice ve UnitInStock bilgilerini getiriniz
select ProductID,
	   ProductName,
	   UnitPrice,
	   UnitsInStock 
from Products 
Where UnitPrice > 20 and UnitPrice < 60

--Id'si 4 ile 7 arasında olan kullnıcıların adını ve soyadını getirtin
select FirstName, 
	   LastName 
from Employees 
where EmployeeID > 4 and EmployeeID < 7

-- Products tablosundan UnitInStock bilgisi 39 yada 29 olan ürünlerin ProductName getirin
select ProductName, UnitsInStock from Products where UnitsInStock = 39 or UnitsInStock = 29

--Between: Between keyword ile and sorgularını daha pratik bir şekilde yazabiliriz
--Products tablosundan UnitPrice'si 30 ile 50 arasında olan ürünlerin Id, ProdcutName ve UnitPrice bilgilerini getirin
select ProductID, ProductName, UnitPrice from Products where UnitPrice between 20 and 50

--In: In operatörü birden fazla or filtremiz var ise kullanılmaktadır.
--Employess tablosundan "TitleOfCourtesy" bilgsi Mr. Dr. yada Ms. olan çalışanların FirstName, LastName, TitleOfCourtesy bilgisini getirin
select EmployeeID, 
	   (FirstName+' '+LastName) as [Full Name], -- FirstName ve LastName sütunlarını birleştirdikten sonra bu sütuna geçici bir isim vermek için [Full Name] yapısını kullandık. Şayet vereceğimiz sutun adı tek kelimeden oluşsaydı "[]" parantezlerine ihtiyaç duymayacaktık.
	   TitleOfCourtesy
	   from Employees where TitleOfCourtesy in('Mr.', 'Dr.', 'Ms.')

--Products tablosundan UnitInStock bilgisi 29, 39 yada 49 olan ürünleri listeleyin
select * from Products where UnitsInStock in(29, 39, 49)

--OrderBy: OrderBy keyword'ü ile sorgu sonucunda dönen veri kümesi üzerinde sort yani sıralama işlemleri yapabiliriz. Bize bu sıralama işlemleri için iki opsiyon sunmaktadır. Birincisi ASC (ascending) yani azdan çoka sırala, ikincisi ise DESC (descending) yani çoktan aza sırala
--Products tablosundan UnitPrice 20 ile 50 arasında olan ürünlerin Id, Name, UnitPrice ve UnitInStock bilgilerini UnitPrice sütununa göre çoktan aza olacak şekllde sıralayınız
select ProductID,
	   ProductName,
	   UnitPrice,
	   UnitsInStock
from Products 
where UnitPrice between 20 and 50
order by UnitPrice desc

--Yaşı 60'dan büyük olan çalışanları listeleyiz
select EmployeeID,
	   (FirstName+' '+LastName) as [Full Name],
	   TitleOfCourtesy,
	   DATEDIFF("YYYY", BirthDate, GETDATE()) as Age
from Employees
where DATEDIFF("YYYY", BirthDate, GETDATE()) > 60
order by Age desc

--Fosil çalışanı bulalım
select TOP 1
	   EmployeeID,
	   (FirstName+' '+LastName) as [Full Name],
	   TitleOfCourtesy,
	   DATEDIFF("YYYY", BirthDate, GETDATE()) as Age
from Employees
where DATEDIFF("YYYY", BirthDate, GETDATE()) > 60
order by Age desc


--Aggegate Functions
--Sum() => İçerisine parametre olarak verdiğimiz değeri toplar
--Toplam Stok Miktarı
select Sum(UnitsInStock) as [Total Stock] from Products

--Çalışanların yaşlarının toplamını bulalım
select SUM(DATEDIFF("YEAR", BirthDate, GETDATE())) as [Total Age] from Employees

--Not: Order Details tablosu sipariş detaylarını tutar
--Spariş numarası (OrderId) 10248 olan siparişten ne kadar para kazanmışım? (Quantity * UnitPrice * (1-Discounted))
select OrderID, 
	  Sum(Quantity * UnitPrice * (1 - Discount)) as Income
from [Order Details] 
where OrderID = 10248 
group by OrderID

--Her bir siparişten ne kadar para kazanmışım ve bunu çoktan aza sıralayınız
select OrderID,
	   Sum(Quantity) as [Total Products],
	   Cast(Sum(Quantity * UnitPrice * (1 - Discount)) as smallmoney) as [Total Income]
from [Order Details]
group by OrderID
order by [Total Income] desc

--Count() => Sorgu sonucunda dönene veri kümesindeki satır sayısını sayar

--Urun baş harfi A-K aralığında olan (Like) ve stok bilgisi 10 ile 50 arasında olan ürünleri kategorilerine göre gruplayınız, ürünlerin adet bilgisini hesaplayarak çoktan aza sıralayınız
select CategoryID,
	   COUNT(*) as Adet
from Products
where (ProductName like '[A-K]%') and (UnitsInStock between 10 and 50)
group by CategoryID
order by Adet desc

--Hangi category altına kaç ürünüm var
select CategoryID,
	   COUNT(*) as Adet
from Products
group by CategoryId
order by Adet Desc

--Hangi Tedarikçiden ne kadar ürün alıyorum (Supplier)
select SupplierID,
	   COUNT(ProductID) as Adet
from Products
group by SupplierID
order by Adet Desc

--Kaç farklı City'de yaşayan çalışanım
select Count(distinct City) from Employees

--Avarage() => Ortalama bulur
--Çalışanlarımızın yaşlarının ortalaması
select Avg(DATEDIFF("YY", BirthDate, GETDATE())) as [Avarege of Age] from Employees

--Siparişlerden elde ettiğim toplam gelirin ortalaması
select Avg(Quantity * UnitPrice * (1-Discount)) from [Order Details]

--En genç ve En yaşlı çalışan
select Min(DATEDIFF("YY", BirthDate, GETDATE())) as [En Geç Çalışan] from Employees

select TOP 1 FirstName, 
	   Max(DATEDIFF("YY", BirthDate, GETDATE())) as Age 
from Employees 
group by FirstName 
order by Age desc

--Having => Sorgu sonucunda dönen veri kümesi üzerinde filtreleme yapmak istediğimizde where kullanabiliyorduk. Lakin devreye herhang bir aggregate function girdiğinde bu fonksiylar sonucunda dönen veri kümesi üzerinde filtreleme yapmak istediğimizde having kullanmak zorundayız. Where burada işimizi görmez.

--Her bir siparişteki toplam tutar 2500 ile 3500 arasında olan siparişleri tutarına göre çoktan aza sıralayarak getiriniz
select OrderID,
	   Cast(Sum(Quantity * UnitPrice * (1 - Discount))as smallmoney) as [Total Price]
from [Order Details]
group by OrderID
having Sum(Quantity * UnitPrice * (1 - Discount)) between 2500 and 3500
order by [Total Price] desc

--Her bir siparişteki toplam ürün miktarı 200'den fazla olan ürünleri çoktan aza listeleyiniz
select OrderID,
	   Sum(Quantity) as [Total Product]
from [Order Details]
group by OrderID
having SUM(Quantity) > 200
order by [Total Product] desc

select * from Products

--Join => Faklı tabloları Id ve ForeignKey'lerinden birbirlerine birleştirerek birden falza tablodan veri çekmemiz eyarayan sistemdir.
--Product ve Category tablolarını join'leyin
select p.ProductID,
	   p.ProductName,
	   c.CategoryID,
	   c.CategoryName
from Products as p
join Categories as c on p.CategoryID = c.CategoryID

--Product ve Supplier tablolarını join'leyin ve 2 eş sütun bilgi getirin
select p.ProductID,
	   p.ProductName,
	   s.SupplierID,
	   s.CompanyName
from Products as p
join Suppliers as s on p.SupplierID = s.SupplierID

--Products tablosundan => ProductId, ProductName,
--Category tablosundan => CategoryId, CategoryName
--Supplier tablosundan => CompanyName, ContactName
select p.ProductID,
	   p.ProductName,
	   c.CategoryID,
	   c.CategoryName,
	   s.CompanyName,
	   s.ContactName
from Products p
join Categories c on p.CategoryID = c.CategoryID
join Suppliers s on s.SupplierID = p.SupplierID


--Ürünlere göre satışlarım nasıl? Yani hangi ürünün satışından ne kadar para kazanmışım?
select p.ProductName,
	   Cast(Sum(od.Quantity * od.UnitPrice * (1 - od.Discount))as decimal) as Income,
	   Sum(od.Quantity) as [Total Product]
from [Order Details] od
join Products p on od.ProductID = p.ProductID
group by p.ProductName
order by [Income], [Total Product] desc

--Categorilerime göre satışlarım nasıl? Hangi categoriden ne kadar para kazanmışım?
select c.CategoryName,
	   Cast(Sum(od.Quantity * od.UnitPrice * (1 - od.Discount))as decimal) as Income
from Categories c
join Products p on c.CategoryID = p.CategoryID
join [Order Details] od on p.ProductID = od.ProductID
group by c.CategoryName
order by Income desc

