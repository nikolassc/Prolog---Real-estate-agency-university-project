# Real Estate Agency – Prolog Project

This project was developed as part of the **Computational Logic and Logic Programming** course  
at the **Aristotle University of Thessaloniki, Department of Informatics**.

It simulates a **real estate agency** system that helps clients find apartments for rent according to their preferences.  
The program supports **interactive**, **batch**, and **auction** modes, and reads apartment and client data from `.pl` files.

---

##Features

### 1.Interactive Mode  
Prompts the user to enter their preferences (minimum area, number of bedrooms, pets, elevator requirement, rent limits, etc.).  
The system displays all apartments that meet the criteria and suggests the **best one** based on:

- Lowest rent  
- If multiple apartments have the same lowest rent → choose the one with the **largest garden**  
- If still tied → choose the one with the **largest total area**

---

### 2.Batch Mode  
Reads multiple client requests from the file `requests.pl` and automatically processes all of them.  
For each client, it prints:
- All compatible apartments  
- The most suitable (recommended) apartment

---

### 3.Auction Mode  
When multiple clients compete for the same apartment, the program runs an **auction process**:
- Each client’s maximum offer is calculated based on their rent preferences and the apartment’s features.  
- The apartment is assigned to the **highest bidder**.  
- Other clients continue bidding for their next preferred apartment until all possible allocations are completed.

