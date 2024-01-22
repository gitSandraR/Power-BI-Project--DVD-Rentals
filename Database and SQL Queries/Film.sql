SELECT 
f.film_id,
f.title "Title",
f.description "Description",
--f.release_year,
--f.language_id,
f.rental_duration "Rental Duration (days)",
f.rental_rate "Rental Rate",
f.length "Film Length (minutes)",
f.replacement_cost "Replacement Cost",
f.rating "Rating",
--f.last_update,
f.special_features "Special Features",
f.fulltext,
--c.category_id,
c.name AS "Category",
--c.last_update,
--l.language_id,
l.name AS "Language"
--l.last_update
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON c.category_id = fc.category_id
INNER JOIN language l ON l.language_id = f.language_id;