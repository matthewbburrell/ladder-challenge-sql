--## Views
--62) Look at the `yum` table. It is the stock data for Yum! Brands, Inc. from 2015 through 2019. Yum! is the company that owns Taco Bell, the best restaurant.

select * from yum;

--63) Query the `yum` table, aggregating by **both** month and year, with the following resulting columns:
--* Year (4 digits)
--* Month
--* Average open, high, low, and close
--* Total volume
--Finally, sort this data so it's in proper chronological order.

select substr(date, 1, 4) as 'Year',
	substr(date,6,2) as 'Month', 
	avg(open) as 'Average Open', 
	avg(high) as 'Average High', 
	avg(low) as 'Average Low', 
	avg(close) as 'Average Close', 
	sum(volume) as 'Total Volume'
from yum;

--64) Save the results of the previous query as a view named `yum_by_month`.


--65) Create a view of `transactions` consisting of only three columns: year, month, and total sales in that month. Call this view `trans_by_month`.


--66) Create a view of `transactions` consisting of only two columns: `employee_id` and the total sales corresponding to that employee. Call this view `trans_by_employee`.