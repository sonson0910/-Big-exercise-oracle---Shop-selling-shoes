
-- Tr?n H?ng Th�i
-- Create tables --
CREATE TABLE Users (
    UserId RAW(16) NOT NULL,
    Email NVARCHAR2(50) NOT NULL,
    Password NVARCHAR2(100) NOT NULL,
    Name NVARCHAR2(50) NOT NULL,
    Role VARCHAR2(10) NOT NULL,
    Address NVARCHAR2(100) NOT NULL,
    Avatar VARCHAR2(300) NOT NULL,
    CONSTRAINT PK_Users PRIMARY KEY (UserId)
);

CREATE TABLE Carts (
    CartId RAW(16) NOT NULL,
    CONSTRAINT PK_Carts PRIMARY KEY (CartId),
    CONSTRAINT FK_Carts_Users_CartId FOREIGN KEY (CartId) REFERENCES Users (UserId) ON DELETE CASCADE
);

CREATE TABLE Categories (
    CategoryId RAW(16) NOT NULL,
    Name NVARCHAR2(50) NOT NULL,
    UpdatedAt TIMESTAMP NOT NULL,
    CONSTRAINT PK_Categories PRIMARY KEY (CategoryId)
);

CREATE TABLE Products (
    ProductId RAW(16) NOT NULL,
    Name NVARCHAR2(100) NOT NULL,
    Price NUMBER NOT NULL,
    Quantity NUMBER NOT NULL,
    Sold NUMBER NOT NULL,
    Description NVARCHAR2(300) NOT NULL,
    MainImage NVARCHAR2(200) NOT NULL,
    CreatedAt TIMESTAMP NOT NULL,
    UpdatedAt TIMESTAMP NOT NULL,
    CONSTRAINT PK_Products PRIMARY KEY (ProductId)
);

CREATE TABLE CategoryProduct (
    CategoriesCategoryId RAW(16) NOT NULL,
    ProductsProductId RAW(16) NOT NULL,
    CONSTRAINT PK_CategoryProduct PRIMARY KEY (CategoriesCategoryId, ProductsProductId),
    CONSTRAINT FK_CategoryProduct_Categories_CategoriesCategoryId FOREIGN KEY (CategoriesCategoryId) REFERENCES Categories (CategoryId) ON DELETE CASCADE,
    CONSTRAINT FK_CategoryProduct_Products_ProductsProductId FOREIGN KEY (ProductsProductId) REFERENCES Products (ProductId) ON DELETE CASCADE
);

CREATE TABLE Orders (
    OrderId RAW(16) NOT NULL,
    EmailUser NVARCHAR2(100) NOT NULL,
    Status NVARCHAR2(100) NOT NULL,
    CreatedAt TIMESTAMP NOT NULL,
    UpdatedAt TIMESTAMP NOT NULL,
    UsersId RAW(16),
    CONSTRAINT PK_Orders PRIMARY KEY (OrderId),
    CONSTRAINT FK_Orders_Users_UserId FOREIGN KEY (UsersId) REFERENCES Users (UserId)
);

CREATE TABLE Reviews (
    ReviewId RAW(16) NOT NULL,
    EmailUser NVARCHAR2(100) NOT NULL,
    Rating NUMBER NOT NULL,
    CommentUser NVARCHAR2(100) NOT NULL,
    CreatedAt TIMESTAMP NOT NULL,
    ProductId RAW(16) NOT NULL,
    CONSTRAINT PK_Reviews PRIMARY KEY (ReviewId),
    CONSTRAINT FK_Reviews_Products_ProductId FOREIGN KEY (ProductId) REFERENCES Products (ProductId) ON DELETE CASCADE
);

CREATE TABLE Images (
    ImageId RAW(16) NOT NULL,
    ImageUrl NVARCHAR2(400) NOT NULL,
    CreatedAt TIMESTAMP NOT NULL,
    UpdatedAt TIMESTAMP NOT NULL,
    ProductId RAW(16) NOT NULL,
    CONSTRAINT PK_Images PRIMARY KEY (ImageId),
    CONSTRAINT FK_Images_Products_ProductId FOREIGN KEY (ProductId) REFERENCES Products (ProductId) ON DELETE CASCADE
);

CREATE TABLE Colors (
    ColorId RAW(16) NOT NULL,
    Name NVARCHAR2(10) NOT NULL,
    ProductId RAW(16),
    CONSTRAINT PK_Colors PRIMARY KEY (ColorId),
    CONSTRAINT FK_Colors_Products_ProductId FOREIGN KEY (ProductId) REFERENCES Products (ProductId)
);

CREATE TABLE Sizes (
    SizeId RAW(16) NOT NULL,
    Name NVARCHAR2(10) NOT NULL,
    ProductId RAW(16),
    CONSTRAINT PK_Sizes PRIMARY KEY (SizeId),
    CONSTRAINT FK_Sizes_Products_ProductId FOREIGN KEY (ProductId) REFERENCES Products (ProductId)
);

CREATE TABLE CartItems (
    CartItemId RAW(16) NOT NULL,
    Name NVARCHAR2(100) NOT NULL,
    Count NUMBER NOT NULL,
    SizeItem NVARCHAR2(10) NOT NULL,
    ColorItem NVARCHAR2(10) NOT NULL,
    PriceItem NUMBER NOT NULL,
    CartId RAW(16) NOT NULL,
    ProductId RAW(16) NOT NULL,
    CONSTRAINT PK_CartItems PRIMARY KEY (CartItemId),
    CONSTRAINT FK_CartItems_Carts_CartId FOREIGN KEY (CartId) REFERENCES Carts (CartId) ON DELETE CASCADE,
    CONSTRAINT FK_CartItems_Products_ProductId FOREIGN KEY (ProductId) REFERENCES Products (ProductId) ON DELETE CASCADE
);

CREATE TABLE OrderItems (
    OrderItemId RAW(16) NOT NULL,
    Name NVARCHAR2(100) NOT NULL,
    Count NUMBER NOT NULL,
    SizeItem NVARCHAR2(10) NOT NULL,
    ColorItem NVARCHAR2(10) NOT NULL,
    Image NVARCHAR2(200) NOT NULL,
    ItemPrice NUMBER NOT NULL,
    OrderId RAW(16) NOT NULL,
    CONSTRAINT PK_OrderItems PRIMARY KEY (OrderItemId),
    CONSTRAINT FK_OrderItems_Orders_OrderId FOREIGN KEY (OrderId) REFERENCES Orders (OrderId) ON DELETE CASCADE
);

-- Helpers --

-- Query
SELECT * FROM "Products";

-- 1. L?y th�ng tin t?t c? ng??i d�ng v� ??n h�ng c?a h? (Truy v?n c? b?n):
SELECT "Users"."UserId", "Email", "Name", "Orders"."OrderId", "Status"
FROM "Users"
LEFT JOIN "Orders" ON "Users"."UserId" = "Users"."UserId";

-- 2. L?y t�n s?n ph?m v� s? l??ng ?� b�n cho m?i ??n h�ng (Truy v?n l?ng nhau):
SELECT "OrderId", "OrderItems"."Name", "Sold"
FROM "OrderItems"
INNER JOIN "Products" ON "OrderItems"."ProductId" = "Products"."ProductId";

-- 3. ??m s? l??ng s?n ph?m theo t?ng danh m?c (Nh�m truy v?n):
SELECT "Categories"."Name", COUNT("Products"."ProductId") AS "TotalProducts"
FROM "Categories"
LEFT JOIN "CategoryProduct" ON "Categories"."CategoryId" = "CategoryProduct"."CategoriesCategoryId"
LEFT JOIN "Products" ON "CategoryProduct"."ProductsProductId" = "Products"."ProductId"
GROUP BY "Categories"."Name";

-- 4. T�nh t?ng gi� tr? ??n h�ng (H�m th?ng k�):
SELECT "OrderId", SUM("ItemPrice") AS "TotalPrice"
FROM "OrderItems"
GROUP BY "OrderId";

-- 5. L?y 5 s?n ph?m m?i nh?t (Truy v?n s?p x?p):
SELECT *
FROM "Products"
ORDER BY "CreatedAt" DESC
FETCH FIRST 5 ROWS ONLY;

-- 6. L?y ?�nh gi� v� b�nh lu?n cho m?t s?n ph?m c? th?? (Truy v?n ?i?u ki?n):
SELECT "Rating", "Comment"
FROM "Reviews"
WHERE "ProductId" = '78B329B32175DBF43DACA4EDB6EAA750';

-- 7. L?y t?t c? c�c m?c trong gi? h�ng v� ??n h�ng (Truy v?n UNION):
SELECT 'Cart' AS ItemType, "Name", "Count"
FROM "CartItems"
UNION
SELECT 'Order' AS ItemType, "Name", "Count"
FROM "OrderItems";

-- 8. L?y th�ng tin s?n ph?m, danh m?c, v� s? l??ng ?� b�n (Truy v?n JOIN k?t h?p nhi?u b?ng):
SELECT "Products"."Name", "Categories"."Name" AS Category, "Sold"
FROM "Products"
LEFT JOIN "CategoryProduct" ON "Products"."ProductId" = "CategoryProduct"."ProductsProductId"
LEFT JOIN "Categories" ON "CategoryProduct"."CategoriesCategoryId" = "Categories"."CategoryId";

-- 9. L?y danh s�ch c�c m�u s?c duy nh?t c� s?n trong s?n ph?m (Truy v?n DISTINCT):
SELECT DISTINCT "Name"
FROM "Colors";

-- 10. T�nh t?ng s? l??ng s?n ph?m trong gi? h�ng (Truy v?n Aggregation):
SELECT "CartId", SUM("Count") AS TotalItems
FROM "CartItems"
GROUP BY "CartId";

    
-- Delete
Delete Users;
Delete Carts;
Delete Products;
Delete Reviews;
Delete CartItems;
Delete Categories;
Delete CategoryProduct;
Delete Orders;
Delete OrderItems;
Delete Sizes;
Delete Colors;
Delete Images;

DROP TABLE "HR"."Users";
DROP TABLE "HR"."Carts";
DROP TABLE "HR"."Categories";
DROP TABLE "HR"."CategoryProduct";
DROP TABLE "HR"."Colors";
DROP TABLE "HR"."Images";
drop table "HR"."OrderItems";
DROP TABLE "HR"."Orders";
DROP TABLE "HR"."Products";
DROP TABLE "HR"."Reviews";
DROP TABLE "HR"."Sizes";
DROP TABLE "HR"."CartItems";
DROP TABLE _EFMigrationsHistory;


-- Cao D??ng
--in danh sach user c� id truy?n v�a
create or replace PROCEDURE list_User(usId raw) is
    cursor l_user is select "Email", "Name", "Address" from "Users" where "UserId" = usId;
    i_user l_user%ROWTYPE;
begin 
    for i_user in l_user loop 
    dbms_output.put_line(i_user."Email" || '-' || i_user."Name" || '-' || i_user."Address");
    end loop;
end;

declare 
    x raw(20);
begin 
    x := '&x';
    list_User(x);
end;
-- loc theo so luong san pham
create or replace procedure list_Product(quan number) is
    cursor l_product is select "ProductId", "Name", "Price", "Sold", "Description" from "Products" where "Quantity" = quan;
    i_pro l_product%rowtype;
begin 
    for i_pro in l_product loop
    dbms_output.put_line(i_pro."ProductId" || '-' || i_pro."Name" || '-' || i_pro."Price" || '-' 
    || i_pro."Sold" || '-' || i_pro."Description");
    end loop;
end;

declare 
    x number;
begin 
    x := &x;
    list_Product(x);
end;
--Tim san pham theo mau sac
create or replace procedure find_shoe(is_color NVARCHAR2 ) is
    cursor l_product is select "Products"."ProductId", "Products"."Name", "Price", "Sold", "Description", "MainImage","CreatedAt", "UpdatedAt" from "Products" join "Colors" on "Products"."ProductId" = "Colors"."ProductId"
    where "Colors"."Name" = is_color;
    i_pro l_product%rowtype;
begin 
    for i_pro in l_product loop
    dbms_output.put_line(i_pro."ProductId" || '-' || i_pro."Name" || '-' || i_pro."Price" || '-' 
    || i_pro."Sold" || '-' || i_pro."Description" || '-' || i_pro."MainImage" || '-' || i_pro."CreatedAt" || '-' || i_pro."UpdatedAt");
    end loop;
end;

declare 
    x nvarchar2(10);
begin 
    x := '&x';
    find_shoe(x);
end; 
--h�m gi?m gi�
create or replace function Giam_gia(maSP raw) return number is
    old_price number;
    new_price number;
begin 
    select "Price" into old_price from "Products" where "ProductId" = maSP;
    if SQL%FOUND then
        new_price := old_price - old_price * 10/100;
    end if;
    return new_price;
EXCEPTION
    when NO_DATA_FOUND then
        return 0;
end;

declare
    cursor l_prv is select "Products"."ProductId", "Name", "Price", "Quantity", "Sold", "Description", "MainImage", "Products"."CreatedAt", "UpdatedAt" from "Products" join "Reviews" 
    on "Products"."ProductId" = "Reviews"."ProductId" where "Reviews"."Rating" > 2;
    i_prv l_prv%rowtype;
    new_price number;
begin
    for i_prv in l_prv loop 
         new_price := Giam_gia(i_prv."ProductId");
        update "Products" set "Price" = new_price where "ProductId" = i_prv."ProductId";
        dbms_output.put_line(i_prv."ProductId" || '-' || i_prv."Name" || '-' || i_prv."Price" || '-' 
    || i_prv."Sold" || '-' || i_prv."Description" || '-' || i_prv."MainImage" || '-' || i_prv."CreatedAt" || '-' || i_prv."UpdatedAt");
        end loop;
end;

--h�m ??m s? s?n ph?m c?a lo?i
create or replace function dem_soSP(tenLoai NVARCHAR2) return number is
    cursor l_cate is select "Categories"."Name" from "Categories" join "CategoryProduct" on "Categories"."CategoryId" = "CategoryProduct"."CategoriesCategoryId"
    join "Products" on "CategoryProduct"."ProductsProductId" = "Products"."ProductId";
    i_cate l_cate%rowtype;
    cursor l_cat is select "Name" from "Categories";
    i_cat l_cat%rowtype;
    cate_count number := 0;
begin
    for i_cate in l_cate loop
            if i_cate."Name" = tenLoai then
            cate_count := cate_count + 1;
            end if;
    end loop;
    return cate_count;
end;
        
declare
    cat_name nvarchar2(50 char);
    c_count number;
begin 
    cat_name := '&cat_name';
    c_count := dem_soSP(cat_name);
    dbms_output.put_line(cat_name || '-' || c_count);
end;

    
    
