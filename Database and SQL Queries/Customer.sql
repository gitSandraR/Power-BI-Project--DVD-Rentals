SELECT
c.customer_id,
--c.store_id,
--c.first_name,
--c.last_name,
c.first_name || ' ' || c.last_name "Customer Name",
c.email "Email",
--c.address_id,
--c.activebool,
--c.create_date,
--c.last_update,
CASE WHEN c.active = 0 THEN 'No' 
	 WHEN c.active = 1 THEN 'Yes' 
	 END AS "Active",
a.address_id,
a.address "Address",
--a.address2,
a.district "District",
--a.city_id,
a.postal_code "Postal Code",
--a.phone,
--a.last_update,
city.city_id,
city.city "City",
--city.country_id,
--city.last_update,
country.country_id,
country.country "Country"
--country.last_update
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ON a.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id
;