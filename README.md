# Bank-Marketing-Analytics

Problem Statement-The data is related to direct marketing campaigns (phone calls) of a Portuguese banking institution. The classification goal is to predict if the client will subscribe to a term deposit. 
The data is related to direct marketing campaigns of a Portuguese banking institution. The marketing campaigns were based on phone calls. Often, more than one contact to the same client was required, in order to access if the product (bank term deposit) would be subscribed or not. 
This dataset contains 4 files.: 
1) bank-additional-full.csv with all examples (41188) and 20 inputs, ordered by date (from May 2008 to November 2010) 
2) bank-additional.csv with 10% of the examples (4119), randomly selected from 1), and 20 inputs. 
3) bank-full.csv with all examples and 17 inputs, ordered by date (older version of this dataset with fewer inputs). 
4) bank.csv with 10% of the examples and 17 inputs, randomly selected from 3 (older version of this dataset with fewer inputs). 
The smallest datasets are provided to test more computationally demanding machine learning algorithms 
Find key metrics and factors and show the meaningful relationships between attributes. 

Architecture of the Bank Marketing Analytics

![image](https://user-images.githubusercontent.com/54885297/230936392-59df36be-b173-4abb-8430-165d4aaa9f0a.png)


Approach-The detailed architecture of the Bank Marketing Analytics has been discussed in the above architecture diagram which gives a overview of the step by step process of the project which gives an idea about flow of the data from original sources to database, then exporting the data from database to importing the data into jupyter notebook by using pandas library for data cleaning process, then for visualize the data, visualization library such Matplotlib and seaborn is used for the purpose and pandas library is used for Feature engineering. Then scikit learn library is used for feature selection , model training, hyperparameter tuning and model evaluation of the data. And finally, deploying the trained data into Power Bi for creating an interactive dashboard.
