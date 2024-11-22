# The Appropriation of State Secularism by Catholics
Data and code to replicate "The Appropriate of State Secularism by Catholics"

This repository contains the data and scripts to reproduce Espinosa & Moizeau "The Appropriation of State Secularism by Catholics"

The project contains folders with data, Stata codes (do-files), and R scripts.

1) Folder "Religiosity" (should be run before NonSwornPriests): contains French data on religiosity in 2013. 
- It reproduces the following tables:
• Descriptive statistics of the variables used in the Religiosity Index (computed at the Département level)
• Correlation matrix between the variables used in the Religiosity Index
• Results (Eigenfactors) of the Principal Component Analysis defining the Religiosity Index

2) Folder "NonSwornPriests": contains historical data on NonSwornPriests which are merged with religiosity data and current economic variables. 
- It reproduces the following tables: 
• Regression of indicators of Catholic practices in 2013 on the proportion of non-sworn priests in 1791 and economic control variables.

3) Folder "Law 3rd Republic": contains historical data on Votes of laws passed under the 3rd Republic. Must be run after "NonSwornPriests" folder.
- It reproduces the following table:
• Probit regression of 3rd Republic laws on the proportion of non-sworn priests in 1791

4) Folder "Constituency Oath" contains historical data about the decision about the Oath for the clergy at the National Assembly.
- It reproduces the following table:
• Regression of the decision of the Clergy representatives to the National Constituent Assembly to take the 1791 Oath on the proportion of non-sworn priests in their electoral district

5) Folder "Education" contains data and do-files related to the education in the 19th and 20th centuries.
- It reproduces the following tables:
• Regression of the share of primary students in secular public schools in the 19th century
on the share of non-sworn priests in 1791 at the (supra) departement level
• Regression of the share of primary students in secular public schools in the 21th century
on the share of non-sworn priests in 1791 at the (supra) departement level


6) Folder "Post-Electoral Studies": contains the French Electoral Studies data and scripts.
- It reproduces the following Table : 
• Regression of attitudes in 2017 on religion.
- It reproduces Figure :
• Sympathy for political parties during the 2017 French presidential elections.

7) Folder "Representative sample survey" contains the data and do-files associated with the survey that we ran in the paper.
- It reproduces the following Figures:
• Opinions of a representative sample of French citizens (Catholics and Atheists) about the
relationship between the religion and the State
• Opinions of French citizens (Catholics and Atheists) about religions and the public sphere.}

