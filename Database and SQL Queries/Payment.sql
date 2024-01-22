SELECT
payment_id,
customer_id,
--staff_id,
rental_id,
amount AS "Amount",
CAST(payment_date AS DATE) AS "Payment Date"
				--extracts date part from timestamp

FROM payment;