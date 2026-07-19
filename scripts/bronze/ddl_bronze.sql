/*
=========================================================================
ddl script:create bronze tables
=========================================================================
script purpose:
      this script creates tables in 'bronze' schema, dropping existing tables
      if they already exist.
      run this script to re-define the ddl structure of 'broze' tables
==========================================================================
*/







if object_id ('bronze.crm_cust_info','u') is not null
drop table bronze.crm_cust_info;
create table bronze.crm_cust_info (
cst_id int,
cst_key nvarchar(50),
cst_firstname nvarchar(50),
cst_lastname nvarchar(50),
cst_material_status nvarchar(50),
cst_gndr nvarchar(50),
cst_create_date date
);
if object_id ('bronze.crm_prd_info','u') is not null
drop table bronze.crm_prd_info;
create table bronze.crm_prd_info(
prd_id int,
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt datetime,
prd_end_dt datetime
);
if object_id ('bronze.crm_sales_details','u') is not null
drop table bronze.crm_sales_details;
create table bronze.crm_sales_details(
sls_ord_num nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id int,
sls_order_dt int,
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int
);
if object_id ('bronze.erp_loc_a101','u') is not null
drop table bronze.erp_loc_a101;
create table bronze.erp_loc_a101(
cid nvarchar(50),
cntry nvarchar(50)
);
if object_id ('bronze.erp_cust_az12','u') is not null
drop table bronze.erp_cust_az12;
create table bronze.erp_cust_az12(
cid nvarchar(50),
bdate date,
gen nvarchar(50)
);
if object_id ('bronze.erp_px_cat_g1v2','u') is not null
drop table  bronze.erp_px_cat_g1v2;
create table bronze.erp_px_cat_g1v2(
id nvarchar(50),
cat nvarchar(50),
subcat nvarchar(50),
maintenance nvarchar(50)
);

create or alter procedure bronze.load_bronze as
begin
    declare @start_time datetime, @end_time datetime,@batch_start_time datetime,@batch_end_time datetime;
	begin try
	  set @batch_start_time=getdate();
	print'===============================';
	print'loading bronze layer';
	print'===============================';

	print'-------------------------------';
	print'loading crm table';
	print'-------------------------------';

	set @start_time=getdate();
	print'>>truncating table: bronze.crm_cust_info';
		truncate table bronze.crm_cust_info;

	print'>>inserting  data into:bronze.crm_cust_info';

		bulk insert bronze.crm_cust_info
		from 'C:\Users\acer\Downloads\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
		firstrow=2,
		fieldterminator = ',',
		tablock
		);
		set @end_time=getdate();
		print'>>load duration:'+cast(datediff(second,@start_time,@end_time) as nvarchar)+'seconds';
		print'>>------------';



		set @start_time=getdate();
		print'>>truncating table: bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;

		print'>>inserting  data into:bronze.crm_prd_info';
		bulk insert bronze.crm_prd_info
		from 'C:\Users\acer\Downloads\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
		firstrow=2,
		fieldterminator = ',',
		tablock
		);
		set @end_time=getdate();
		print'>>load duration:'+cast(datediff(second,@start_time,@end_time) as nvarchar)+'seconds';
		print'>>------------';



		set @start_time=getdate();
		print'>>truncating table: bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;

		print'>>inserting  data into:bronze.crm_sales_details';

		bulk insert bronze.crm_sales_details
		from 'C:\Users\acer\Downloads\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with (
		firstrow=2,
		fieldterminator = ',',
		tablock
		);
		set @end_time=getdate();
		print'>>load duration:'+cast(datediff(second,@start_time,@end_time) as nvarchar)+'seconds';
		print'>>------------';



	
	print'-------------------------------';
	print'loading erp table';
	print'-------------------------------';


	set @start_time=getdate();
	print'>>truncating table: bronze.erp_loc_a101';
		truncate table bronze.erp_loc_a101;

		print'>>inserting  data into:bronze.erp_loc_a101';
		bulk insert bronze.erp_loc_a101
		from 'C:\Users\acer\Downloads\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		with(
		firstrow=2,
		fieldterminator=',',
		tablock
		);
		set @end_time=getdate();
		print'>>load duration:'+cast(datediff(second,@start_time,@end_time) as nvarchar)+'seconds';
		print'>>------------';



		set @start_time=getdate();
		print'>>truncating table: bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12;

		print'>>inserting  data into:bronze.erp_cust_az12';
		bulk insert bronze.erp_cust_az12
		from 'C:\Users\acer\Downloads\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		with(
		firstrow=2,
		fieldterminator=',',
		tablock
		);
		set @end_time=getdate();
		print'>>load duration:'+cast(datediff(second,@start_time,@end_time) as nvarchar)+'seconds';
		print'>>------------';



		set @start_time=getdate();
		print'>>truncating table: bronze.erp_px_cat_g1v2';
		truncate table bronze.erp_px_cat_g1v2;

		print'>>inserting  data into:bronze.erp_px_cat_g1v2';
		bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\acer\Downloads\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		with(
		firstrow=2,
		fieldterminator=',',
		tablock
		);
		set @end_time=getdate();
		print'>>load duration:'+cast(datediff(second,@start_time,@end_time) as nvarchar)+'seconds';
		print'>>------------';

		set @batch_end_time=getdate();
		print'========================='
		print'loading bronze layer is completed';
		print'the total duration is :'+ cast(datediff(second,@batch_start_time,@batch_end_time)as nvarchar)+'seconds';
		print'========================='


		end try
		begin catch 
		print'======================='
		print'error occured during loading broze layer'
		print'error message'+cast(error_message()as nvarchar);
		print'error message'+cast(error_state()as nvarchar);
		print'======================='

		end catch
end

