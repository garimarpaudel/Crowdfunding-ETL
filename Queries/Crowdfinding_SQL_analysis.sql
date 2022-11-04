-- Retrieve all the number of backer_counts in descending order for each `cf_id` for the "live" campaigns. 

SELECT cf_id, backers_count
INTO backers_by_cf_id
FROM campaign
WHERE (outcome = 'live')
GROUP BY cf_id
ORDER BY backers_count DESC;
-- Check the table
SELECT * FROM backers_by_cf_id;

-- Alternative query to retrieve the same table
SELECT ca.cf_id, ca.backers_count
INTO backers_by_cf_id
FROM campaign AS ca
	LEFT JOIN backers AS ba
	ON ba.cf_id = ca.cf_id
WHERE (ca.outcome = 'live')
GROUP BY ca.cf_id
ORDER BY ca.backers_count DESC;
-- Check the table
SELECT * FROM backers_by_cf_id;



-- Using the "backers" table confirm the results in the first query.

SELECT cf_id, COUNT(backer_id) AS count_fr_backers
INTO backers_by_cf_id_fr_backers
FROM backers
GROUP BY cf_id
ORDER BY count_fr_backers DESC;
-- Check the table
SELECT * FROM backers_by_cf_id_fr_backers;

-- Create comparison table of backer_counts by cf_id
DROP TABLE IF EXISTS campaign_backers_diff CASCADE;
SELECT ca.cf_id,
	ca.backers_count,
	ba.count_fr_backers
INTO campaign_backers_diff
FROM backers_by_cf_id AS ca
	LEFT JOIN backers_by_cf_id_fr_backers AS ba
	ON ca.cf_id=ba.cf_id
ORDER BY count_fr_backers DESC;
-- Check the table
SELECT * FROM campaign_backers_diff;



-- Create a table, "email_contacts_remaining_goal_amount", that has the first and last name, and email address of each contact.
-- And, the amount left to reach the goal for all "live" projects in descending order. 

SELECT co.first_name,
	co.last_name,
	co.email,
	(ca.goal - ca.pledged) AS "Remaining Goal Amount"
INTO email_contacts_remaining_goal_amount
FROM campaign AS ca
	LEFT JOIN contacts AS co
	ON co.contact_id = ca.contact_id
WHERE (ca.outcome = 'live')
ORDER BY "Remaining Goal Amount" DESC;
-- Check the table
SELECT * FROM email_contacts_remaining_goal_amount;



-- Create a table, "email_backers_remaining_goal_amount" that contains the email address of each backer in descending order, 
-- and has the first and last name of each backer, the cf_id, company name, description, 
-- end date of the campaign, and the remaining amount of the campaign goal as "Left of Goal". 

SELECT ba.email,
	ba.first_name,
	ba.last_name,
	ca.cf_id,
	ca.company_name,
	ca.description,
	ca.end_date,
	(ca.goal - ca.pledged) AS "Left of Goal"
INTO email_backers_remaining_goal_amount
FROM backers AS ba
	LEFT JOIN campaign AS ca
	ON ca.cf_id = ba.cf_id
WHERE (ca.outcome = 'live')
ORDER BY ba.last_name, ba.email ASC;
-- Check the table
SELECT * FROM email_backers_remaining_goal_amount;


-- Double check the table from crowdfunding_db
SELECT * FROM category;
SELECT * FROM subcategory;
SELECT * FROM contacts;
SELECT * FROM campaign;
SELECT * FROM backers;