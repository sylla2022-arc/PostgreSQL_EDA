-- Exercice:
-- 1. Nous voulons connaitre les différentes notes (colonne rating) des états
-- unis (PG PG-13, R ect).présentes dans la table notes.

-- 2.  Nous souhaitons les #ts taux de location (colonne rental_rate) présents dans la 
-- table film.
--3. Compter le nombre de différents rating et rental_rate.

select distinct rating from film ;
select distinct rental_rate from film;
select count(distinct rating) from film;
select count(distinct  rental_rate) from film ;

--- Le nombre d location par mois
select extract(YEAR from rental_date), extract(MONTH from rental_date), count(rental_id) as Total_rental
from rental
group by 1,2  -- 1 =  extract(YEAR from rental_date) et etc 
order by Total_rental desc ;
select * from rental;
-- Nombre de location de dvd film par mois
select rental_date, count(rental_id) as Total_rental
from rental
group by rental_date
order by Total_rental desc ;

--- Le nombre d location par an puis par mois
select extract(YEAR from rental_date), extract(MONTH from rental_date),
count(rental_id) as Total_rental, count(distinct customer_id) as unique_rental,
count(rental_id)/count(distinct customer_id) as average_rental_int, 
1.0*count(rental_id) /count(distinct customer_id) as average_rental_float

from rental
group by 1,2  -- 1 =  extract(YEAR from rental_date) et etc 
order by Total_rental ASC ;

--- Exploration avec where
--- table client
select * from customer;

select * from address;

--Mision 2:  
-- 1. Je viens d'ajouter à la liste des films présents dans le
-- magasin un nouveau film qui pourrait plaire à 'Gloria Cook',
-- pouvez vous me donner son adress email afin que je puisse lui envoyer
--un message ?

-- 2. On m'a parlé d'un film qui se nomme 'Texas Watch' et j'aimerai savoir si
--- ça peut me plaire. Pouvez vous me fournir une description de ce film ?

-- 3. Un client est en retard pour rendre son film la semaine dernière, nous avons
-- noté son adresse '270 Toulon Boulevard'. Pouvez-vous trouver son numéro pour 
-- qu'on le prévienne.

select * from customer ;


select customer.first_name, customer.last_name,  customer.email
from customer 
where  customer.first_name = 'Gloria' and customer.last_name = 'Cook'
;

select film.title, film.description
from film
where film.title = 'Texas Watch'
;

select address.address, address.phone 
from address
where address.address = '270 Toulon Boulevard';

-- in et NOT IN
select customer_id, rental_date, return_date
from rental
where customer_id  in  (1,2, 3)
order by rental_date asc ;

-- COMMANDE LIKE
select first_name, last_name
from customer
where first_name LIKE '%er_' ;

-- Mission : 
--1. Compter le nombre d'acteur dont le nom de famille commence par P
--2. Compter le nombre de films qui contient 'Thruman' dans leur titre
--3. Quel est le client qui a le plus grand Customer ID et dont le prénom 
-- commence par 'E' et a un Address ID inférieur à 500 ?

select count(last_name)
from actor
where last_name LIKE 'P%' ;

select count(title)
from film
where title LIKE '%Truman%';

select customer_id , first_name, last_name, address_id
from customer
where (first_name LIKE 'E%') and (address_id <500)
order by customer_id desc 
limit 1;
-- Nous avons 2 équipes différentes staff_id 1 et staff_id 2. 
-- 1. Nous souhaitons donner un bonus à l'équipe qui a obtenu le plus de paiement.
-- 2. Combien de paiement a réalisé chaque équipe et pour quel montant ?

select staff_id, count(staff_id), sum(amount) as Montant_Total
from payment 
GROUP BY staff_id
order by Montant_Total desc;


-- Exercice : Un cabinet d'audit est entrain d'auditer notre magasin et 
-- souhaiterait connaître le coût moyen de remplacement des films par lettres
-- de notation( R, PG, G etc)

select rating, round(sum(replacement_cost)/ count(film_id), 2)

from film 
GROUP BY rating
;
-- select  * from film ;

-- Mission : Nous voulons distribuer des coupons à nos 5 clients
-- qui ont dépensé le plus d'argent dans notre magasin.
-- Obtenez les IDs de ces clients.
select * from customer
where customer_id = 341;

select * from payment ;

select customer_id, sum(amount) as somme_dépensée
from payment
group by customer_id
order by somme_dépensée desc
limit 5;



-- Commande HEAVING
select * from film;

select rating,  avg(rental_rate)
from film 
where rating in ('R', 'PG', 'G' )
group by rating 
HAVING  avg(rental_rate)> 3;

-- Mission 1: Nous souhaitons distribuer une carte de payment avantageuse
-- pour nos meilleurs clients. Sont eligibles les clients qui totalisent au 
-- au moins 30 transaction de payments (table_payment)
-- Quels clients sont donc éligibles (donner leurs IDs)
select customer_id, count(payment_id)
from payment
group by customer_id
having count(payment_id) > 30;


-- Mision 2: Obtenir les notation dont la duréé de location moyenne est > 5j
select rating, avg(rental_duration)
from film 
group by rating
having avg(rental_duration) > 5;

-- Mission 3: Obtenir les IDs des cients qui ont payé plus de 110 $ à 
--l'équipe staff_2
select * from payment ;
select  customer_id, sum(amount)
from payment 
where staff_id = 2
group by customer_id
having sum(amount) > 110;
-- Commande JOIN
select * from payment ;

select customer.customer_id, first_name, last_name, email, amount, payment_date
from customer
inner join payment on customer.customer_id = payment.customer_id
order by first_name;

-- INNER JOIN
SELECT  store_id, title, count(store_id)
FROM inventory
INNER JOIN film on inventory.film_id = film.film_id
group by store_id, title 
order by title;

select name, title
from film
join language ON film.language_id = language.language_id
;
-- ##########################################################
select title, name  movie_language
from film
inner join  language l ON film.language_id = l.language_id
;
--- LEFT OUTER JOIN
SELECT f.film_id,title,  store_id, inventory_id
FROM film as f
LEFT OUTER JOIN inventory as i on f.film_id= i.inventory_id
order by title ;

--##################################################
---Challenge : 
-- Afficher la liste de tous les  films accompagnés de la catégorie de film
-- auquelle ils appartiennent ainsi que la langue du film.
select * from film_category ;

select f.film_id,  title, c.name as Category_name, l.name as Language_name
from film_category as fc
inner join film as f on f.film_id = fc.film_id
inner join category as c on c.category_id = fc.category_id
inner join language as l on l.language_id = f.language_id
;

--- Challenge Marketing 1: Trouver le film qui rapporte plus
--  Afficher tous les films avec leurs nombre de location et le revenu que 
-- chaque film a généré.
-- Table utiles : rental pour le nombre de location et films pour le prix
-- par locationde chaque film.
-- INDICE : Revenu par film = prix location*  nombre de location par film

select f.title, count(rental_id), count(rental_id)*rental_rate as revenu_film
from film as f

inner join inventory as i on i.film_id = f.film_id
inner join rental as r on r.inventory_id = i.inventory_id
group by title, rental_rate
order by revenu_film desc
limit 5;

---####################################################################
--Challenge Marketing 2: Quel est le magasin qui a vendu plus (store 1 ou store2)
-- Afficher le total de vente  de chaque magasin (store_id)
-- Indice : Montant de la colone amount de la table payment.

select s.staff_id, store_id, sum(p.amount) as revenu
from staff  as s
inner join payment as p on s.staff_id = p.staff_id
group by S.staff_id
order by  revenu desc
;
-- Challenge marketing 3: Combien y'a t-il de location pour les films 
-- d'actions, pour les comdédies et pour les films d'animation ?
-- Category : action, Comedy, Animation
-- Afficher le total location à côté des 3 types de films.
select c.name, count(rental_id) as Location_count
from category as c
inner join film_category as fc on c.category_id = fc.category_id
inner join film as f on f.film_id = fc.film_id
inner join inventory as i on f.film_id = i.film_id
inner join rental as r on r.inventory_id = i.inventory_id
where name = 'Comedy' or name = 'Action' or name = 'Animation'
group by name
order by Location_count  desc
;

-- Challenge MAKETING 4: Envoyer une offre promotionnelle à tous les clients
-- qui ont loué au moins 40 films .
-- Afficher les emails des clients qui ont loué au moins 40 films pour les 
-- contacter.
select  c.customer_id , first_name, last_name, email, 
count(rental_id) as Total_location
from rental as r
inner join customer as c on c.customer_id = r.customer_id
group by C.customer_id 
HAVING count(rental_id) >= 40
Order by Total_location desc
;
;





















