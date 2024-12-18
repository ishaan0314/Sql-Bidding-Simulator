This project implements a database-driven auction simulator for an NBA fantasy draft. It uses SQL to enforce business logic and simulate real-world dynamics, including team preferences, bidding constraints, and player allocations. Key features include:

* Structured data architecture with entities for players, teams, bids, and preferences connected via foreign keys to minimize redundancy.
* Sequential bidding in lots, ensuring fairness and adherence to predefined rules such as budget constraints and position preferences.
* Stored procedures and triggers to manage live budget updates, validate bids, and enforce constraints like maximum bid percentages.
* Comprehensive result tables and queries to analyze draft outcomes, including player assignments, bid amounts, and budget utilization.
 
This system demonstrates SQL's capability to model complex scenarios and provides a foundation for more advanced features like trades, dynamic budgeting, and game theory integration.
