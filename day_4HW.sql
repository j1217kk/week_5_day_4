CREATE OR REPLACE PROCEDURE sevenDayLateFee (
	fee DECIMAL -- amount for late fee
)
LANGUAGE plpgsql
AS $$
BEGIN
	-- ADD a late fee to customer payment amount
	UPDATE payment
	SET amount = amount + (fee
	WHERE rental_id IN (
		SELECT rental_id
		FROM "rental"
		WHERE rental_duration >= INTERVAL '7' day
	);
	COMMIT;
END;
$$

SELECT * FROM rental WHERE rental_duration >= INTERVAL '7' day;

SELECT * FROM rental ORDER BY rental_id DESC;

SELECT * FROM payment WHERE RENTAL_ID = 16048;

CALL sevenDayLateFee(1.00);

ALTER TABLE customer
ADD COLUMN platinum BOOLEAN;

SELECT * FROM customer;

CREATE OR REPLACE PROCEDURE setPlatinums(
)LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE "customer"
	SET platinum = true
	WHERE customer_id IN(
		SELECT customer_id
		FROM payment
		GROUP BY customer_id
		HAVING SUM(amount) > 200
		);
	UPDATE "customer"
	SET platinum = false
	WHERE customer_id IN(
		SELECT customer_id
		FROM payment
		GROUP BY customer_id
		HAVING SUM(amount) <= 200
		);
	COMMIT;
END;
$$
		
