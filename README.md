# Ad-Hoc-reports-for-a-NBFC-Insurance-company

## Problem statement

Insurance companies generate large volumes of data across customers, policies, agents, and claims. However, raw data alone does not answer critical business questions. The problem is “how can we use SQL to transform insurance data into actionable business insights such as premium performance, claim behavior, and agent effectiveness?”


## Real-life Application
In Insurance companies, analysts use SQL to generate key insights to key stakeholders. Few key insights for key Stakeholders are listed below.

[Executive]()

  - Total premium collected
  - Total claims paid
  - Loss ratio

[Sales Head]()

  - Top performing agents
  - Premium by policy type
  - Premium trend over months

[Operations]()
  - Average claim amount
  - Claims frequency
  - Pending vs closed claims

[Customer Insights]()
  - Renewal analysis
  - High risk customers

## Dataset Overview

we solve this problem using a relational insurance dataset and step-by-step SQL queries. This project uses four simple tables, each with rows shown in brackets, generated for demo purposes:
- customers (200)
- agents (30)
- policies (201)
- claims (200)


Dataset Overview
-----
1. Customers Table
##### This represents insurance customers. Columns and their description are here below:
  - customer_id : Unique customer ID
  - customer_name : Full name
  - city : Location of customer
  - join_date : First onboarding date
-----
2. Agents Table

##### This represents sales agents selling policies. Columns and their description are here below:

  - agent_id : Unique ID for the agent
  - agent_name : Agent Name
  - zone: Region from North, East, West, South
  - rating: rating of the agent
  - status : Active / Inactive
-----
3. Policies Table
##### This represents policies sold by agents to customers. Columns and their description are here below:
  - policy_id : Policy number
  - customer_id : Customer ID
  - agent_id : Sales agent
  - policy_type : Health / Auto / Home / Life
  - start_date : Start date of the policy
  - end_date : End date of the policy
  - premium : Premium amount
-----
4. Claims Table
##### This represents Claims reported against policies.
  - claim_id : Claim ID
  - policy_id : Linked policy ID
  - claim_date : Date of claim
  - claim_amount : Amount claimed
  - claim_status : Approved/ Pending/ Rejected
