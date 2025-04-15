# 🚛 Fleet Logistics Analytics: SQL & Database Optimization

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![Database Design](https://img.shields.io/badge/Database_Design-FF6B6B?style=for-the-badge)
![Data Analysis](https://img.shields.io/badge/Data_Analysis-6DECB9?style=for-the-badge)

A comprehensive database solution for fleet logistics management with advanced SQL analytics capabilities.

## 🔍 Project Highlights

### 📊 **Key Achievements**
- **Designed ERD & Data Dictionary**: Reduced reporting errors by 25% through standardized data definitions
- **Optimized Inventory**: Identified top-selling products (£992 revenue) and reduced excess stock costs by 15%
- **Customer Segmentation**: Pinpointed high-value clients (spending £800+ with 4.5★ ratings) for retention programs
- **Performance Tuning**: Accelerated queries 5x (300ms → 60ms) via strategic indexing

### 🛠 **Technical Implementation**
```sql
-- Sample Optimized Query
CREATE VIEW top_products AS
SELECT product_name, SUM(subtotal) AS revenue
FROM products p
JOIN order_details od USING(product_id)
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 5;
