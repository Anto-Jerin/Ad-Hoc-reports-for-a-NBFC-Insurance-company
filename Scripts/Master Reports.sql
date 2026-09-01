1. Total Premium Collected
Insight: This gives total business revenue from insurance premiums.

SELECT FORMAT(sum([premium]) , ‘#,###,###’) as total_premium
FROM [policies]

2: Total Claims Paid
Insight: This gives total claims paid from insurance premiums.

SELECT FORMAT(sum([claim_amount]) , ‘#,###,###’) as total_claims
FROM [claims]

3: Average Claim Amount paid by Policy Type
Insight: Very commonly used by underwriting and pricing teams. Answers “which insurance products have higher average claim severity?”

SELECT
POL.policy_type,
COUNT(CLM.claim_id) as claims_count,
ROUND(AVG(clm.claim_amount),2) as avg_claim_amount
FROM [claims] CLM
JOIN [policies] POL ON CLM.policy_id = POL.policy_id
WHERE claim_status = ‘Approved’
GROUP BY POL.policy_type
ORDER BY avg_claim_amount DESC;

4: Premium by Policy Type

Insight: This shows which product line brings the most income.

SELECT
policy_type,
COUNT(*) as policies_sold,
FORMAT(SUM(premium) , ‘#,###,###’) as total_premium,
FORMAT(AVG(premium) , ‘#,###,###’) as average_premium
FROM [policies]
GROUP BY policy_type
ORDER BY total_premium DESC

5: Region-wise Premium

Insight: This compares business performance across regions.

SELECT
CMR.city,
COUNT(POL.policy_id) as policies_sold,
FORMAT(SUM(POL.premium) , ‘#,###,###’) as region_premium
FROM [policies] POL
JOIN [customers] CMR ON POL.customer_id = CMR.customer_id
GROUP BY CMR.city
ORDER BY region_premium

6: Monthly Premium Trend

Insight: This shows premium trend by month.

SELECT
FORMAT(DATEFROMPARTS(YEAR(start_date), MONTH(start_date),1), ‘yyyy-MMM’) AS [year-month],
FORMAT(SUM(premium), ‘#,###,###’) AS monthly_premium
FROM [policies]
GROUP BY
DATEFROMPARTS(YEAR(start_date), MONTH(start_date), 1)
ORDER BY
DATEFROMPARTS(YEAR(start_date), MONTH(start_date), 1)

7: Agent Performance Ranking

Insight: This identifies top-performing and low-performing agents.

SELECT
AGN.zone,
AGN.agent_name,
COUNT(POL.policy_id) as policies_sold,
FORMAT(SUM(COALESCE(POL.premium,0)), ‘##,###,##0’) as agent_premium
FROM [agents] AGN
LEFT JOIN [policies] POL ON AGN.agent_id = POL.agent_id
GROUP BY AGN.agent_name,AGN.zone
ORDER BY SUM(COALESCE(POL.premium,0)) DESC

8: Claim Frequency by Policy Type

Insight: This shows which policy types are more prone to claims.

SELECT
POL.policy_type,
COUNT(CLM.claim_id) as claims_count,
FORMAT(AVG(CLM.claim_amount), ‘##,###,##0’) as avg_claim_amount
FROM [claims] CLM
LEFT JOIN [policies] POL ON CLM.policy_id = POL.policy_id
GROUP BY POL.policy_type
ORDER BY claims_count DESC

9: Loss Ratio

Insight: This is a core metric for insurance profitability.

WITH cte_table_tot_premium AS (
SELECT SUM(premium) as total_premium FROM [policies]
),
cte_table_tot_claims AS (
SELECT SUM(claim_amount) as total_claims FROM [claims]
)
SELECT
total_premium,
total_claims,
(total_claims * 100 / total_premium) AS Loss_ratio_percent
from cte_table_tot_premium, cte_table_tot_claims

10: Open vs Closed Claims

Insight: This shows operational workload and pending liability.

SELECT
claim_status,
COUNT(*) as claims_count,
FORMAT(SUM(claim_amount),’##,###,###’) as total_claims
FROM [claims]
GROUP BY claim_status

11: Renewal Rate

Insight: This measures how many customers continue their policies.

WITH renewal AS (
SELECT
customer_id,
policy_type,
start_date,
end_date,
LAG(end_date) OVER (
PARTITION BY customer_id,policy_type,policy_id
ORDER BY start_date
) AS prev_end_date
FROM [policies]
)

SELECT
policy_type,
CAST(
SUM(
CASE
WHEN prev_end_date IS NOT NULL
AND start_date <= DATEADD(day, 3, prev_end_date)
THEN 1 ELSE 0
END
) * 100.0 / COUNT(*)
AS DECIMAL(5,2)) AS renewal_rate_percent
FROM renewal
GROUP BY policy_type
ORDER BY renewal_rate_percent DESC

12: High-Risk Customers (Customers with 4 or more claims)

Insight: This is useful for risk assessment and premium adjustment

SELECT
CMR.customer_id,
CMR.customer_name,
COUNT(CLM.claim_id) AS claim_count,
SUM(CLM.claim_amount) as claims_amount
FROM [customers] CMR
JOIN [policies] POL ON CMR.customer_id = POL.customer_id
JOIN [claims] CLM ON POL.policy_id = CLM.policy_id
GROUP BY CMR.customer_id, CMR.customer_name
HAVING COUNT(CLM.claim_id) >= 4
ORDER BY claim_count DESC

13: Region-Wise Top 3 Agents by Premium

Insight: This provides top 3 Agents by premium for each region
