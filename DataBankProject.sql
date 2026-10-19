use cw ;

# 1. How many different nodes make up the Data Bank network? 

select  count(distinct node_id) as Number_of_Nodes from customer_nodes ;

#2  How many nodes are there in each region?

select count(node_id) as Number_of_Nodes,region_name from customer_nodes c
join regions r  on c.region_id=r.region_id group by region_name ;

#  3. How many customers are divided among the regions?

select count(distinct customer_id) as Number_of_customer,region_name from customer_nodes c
join regions r on c.region_id=r.region_id group by region_name ;

# 4 . Determine the total amount of transactions for each region name.

select sum(txn_amount) as total_No_transaction,region_name from customer_transactions c
join customer_nodes n on n.customer_id=c.customer_id 
join regions r on r.region_id=n.region_id group by region_name ;

# 5. How long does it take on an average to move clients to a new node?

select round(avg(datediff(end_date,start_date)),2) as Average_time from customer_nodes 
where end_date != '9999-12-31' ;

# 6. What is the unique count and total amount for each transaction type?

select count(*) as Unique_count ,sum(txn_amount) as total_amount,txn_type
from customer_transactions group by txn_type ;

# 7. What is the average number and size of past deposits across all customers?

select round(count(customer_id)/(select count(distinct customer_id) from customer_transactions),2) as Avg_deposit_amount
from customer_transactions where txn_type = 'deposit' ;

# 8. For each month - how many Data Bank customers make more than 1 deposit
# and at least either 1 purchase or 1 withdrawal in a single month?

with trans_month as (
select customer_id, month(txn_date) as Month ,
sum(if(txn_type='deposit',1,0)) as depositcount,
sum(if(txn_type='purchase',1,0)) as purchasecount,
sum(if(txn_type='withdrawal',1,0)) as withdrawalcount 
from customer_transactions group by customer_id,Month
)
select count(distinct customer_id)  as Customer_count ,Month 
from trans_month where depositcount>1 and purchasecount =1 or withdrawalcount =1 
group by Month ;