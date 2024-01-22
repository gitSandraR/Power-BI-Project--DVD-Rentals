SELECT 
rental_id,
CAST(rental_date AS DATE) AS "Rental Date",
					--extracts date part of timestamp
inventory_id,
customer_id,
CAST(return_date AS DATE) AS "Return Date"
					--extracts date part of timestamp
--staff_id,
--last_update
FROM rental;