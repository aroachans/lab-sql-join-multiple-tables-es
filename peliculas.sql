USE SAKILA;
-- 1. Escribe una consulta para mostrar para cada tienda su ID de tienda, ciudad y país.

SELECT STORE_ID, C.CITY, D.COUNTRY
FROM STORE A
INNER JOIN ADDRESS B
ON A.ADDRESS_ID = B.ADDRESS_ID
INNER JOIN CITY C
ON B.CITY_ID = C.CITY_ID
INNER JOIN COUNTRY D 
ON C.COUNTRY_ID = D.COUNTRY_ID;


-- 2. Escribe una consulta para mostrar cuánto negocio, en dólares, trajo cada tienda.
WITH STORE_ADDRESS_CTE AS (
    SELECT store_id, c.city, d.country
    FROM store a
    INNER JOIN address b ON a.address_id = b.address_id
    INNER JOIN city c ON b.city_id = c.city_id
    INNER JOIN country d ON c.country_id = d.country_id
)

SELECT st.store_id, CONCAT(st.city, ', ', st.country) AS Store_Location, SUM(amount) AS amount
FROM store_address_cte st
INNER JOIN inventory inv ON st.store_id = inv.store_id
INNER JOIN rental rt ON inv.inventory_id = rt.inventory_id
INNER JOIN payment pm ON rt.rental_id = pm.rental_id
GROUP BY st.store_id, Store_Location;

-- 3. ¿Cuál es el tiempo de ejecución promedio de las películas por categoría?
SELECT ct.name AS category, AVG(length) AS avg_ejecucion
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category ct ON fc.category_id = ct.category_id
GROUP BY ct.name;

-- 4.¿Qué categorías de películas son las más largas?
SELECT ct.name AS category, AVG(length) AS avg_ejecucion
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category ct ON fc.category_id = ct.category_id
GROUP BY ct.name
ORDER BY avg_ejecucion DESC
LIMIT 3;

-- 5. Muestra las películas más alquiladas en orden descendente.
SELECT f.title AS movie_title, COUNT(*) AS rental_count
FROM film f
INNER JOIN inventory inv ON f.film_id = inv.film_id
INNER JOIN rental rt ON inv.inventory_id = rt.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC;

-- 6. Enumera los cinco principales géneros en ingresos brutos en orden descendente.
SELECT c.name AS genre, SUM(p.amount) AS total_revenue
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
INNER JOIN film f ON fc.film_id = f.film_id
INNER JOIN inventory inv ON f.film_id = inv.film_id
INNER JOIN rental r ON inv.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY total_revenue DESC
LIMIT 5;

-- 7. ¿Está "Academy Dinosaur" disponible para alquilar en la Tienda 1?
   SELECT DISTINCT
    d.store_id,
    a.title AS title,
    b.inventory_id,
    CASE
        WHEN return_date IS NOT NULL THEN 'Available'
        ELSE 'Not available'
    END AS Availability
FROM
    film a
INNER JOIN
    inventory b ON a.film_id = b.film_id
LEFT JOIN
    rental c ON b.inventory_id = c.inventory_id
LEFT JOIN
    store d ON d.store_id = b.store_id
WHERE
    a.title = 'Academy Dinosaur' AND
    d.store_id = 1;









