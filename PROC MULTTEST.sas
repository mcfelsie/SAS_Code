/*******************************************
  Code to compare coverage probabilties
   allind1 is a data set containing two variables: 
   method is the name of the confidence interval method 
   ind1 is binary variable indicating whether the confidence interval contained the true p 
********************************************/

/* Comparing coverage probabilties using ANOVA */
/* ChiSq Results to see if at least one method is different*/
ods rtf file="P:\STATS\StratcomMethodsStudy\CETResults_Oct2013\ChiSq.rtf";
proc freq data=allind1;
tables ind1*method /plots=none chisq; /* this is comparing the proportion of successes (ind1) by each method */
by n c p; /* testing for difference cases of n, c, and p. you might need a 'by' statement */
output out=test chisq n; /* outputs chisq results to SAS dataset called 'test' */
where round(c, 0.01) in (0.90, 0.95) and n in (15, 30, 45, 60, 75) and round(p, 0.01) in (0.70, 0.75, 0.80, 0.85, 0.90, 0.95, 0.99);
run;
ods rtf close;

/* ChiSq results were significant, this is doing pairwise comparisons */
ods rtf file="P:\STATS\StratcomMethodsStudy\CETResults_Oct2013\CovProb_FreemanTukey.rtf"; /* outputs results to word doc*/
proc multtest data=allind1 out=ftresults; 
  where round(c, 0.01) in (0.90, 0.95) and n in (15, 30, 45, 60, 75) and round(p, 0.01) in (0.70, 0.80, 0.90, 0.95, 0.98);
  by n c p; /* may or may not need 'where' and 'by' statements */
  test ft(ind1);  /* need this 'test' statement*/
  class method;
  contrast 'AdjA vs AdjJ'  -1 1 0 0 0 0 0 0 0; /* Method 1 vs Method 2 */
  contrast 'AdjA vs AdjU'  -1 0 1 0 0 0 0 0 0; /* Method 1 vs Method 3 */
  contrast 'AdjA vs Bork'  -1 0 0 1 0 0 0 0 0; /* Method 1 vs Method 4 */
  contrast 'AdjA vs Bayes' -1 0 0 0 1 0 0 0 0; /* etc */
  contrast 'AdjA vs Clop'  -1 0 0 0 0 1 0 0 0;
  contrast 'AdjA vs Logit' -1 0 0 0 0 0 1 0 0;
  contrast 'AdjA vs Score' -1 0 0 0 0 0 0 1 0;
  contrast 'AdjA vs Wald'  -1 0 0 0 0 0 0 0 1; 
/* */
  contrast 'AdjJ vs AdjU'  0 -1 1 0 0 0 0 0 0;  /* Method 2 vs Method 3 */
  contrast 'AdjJ vs Bork'  0 -1 0 1 0 0 0 0 0;  /* Method 2 vs Method 4 */
  contrast 'AdjJ vs Bayes' 0 -1 0 0 1 0 0 0 0;
  contrast 'AdjJ vs Clop'  0 -1 0 0 0 1 0 0 0;
  contrast 'AdjJ vs Logit' 0 -1 0 0 0 0 1 0 0;
  contrast 'AdjJ vs Score' 0 -1 0 0 0 0 0 1 0;
  contrast 'AdjJ vs Wald'  0 -1 0 0 0 0 0 0 1; 
/* */
  contrast 'AdjU vs Bork'  0 0 -1 1 0 0 0 0 0;  /* Method 3 vs Method 4 */
  contrast 'AdjU vs Bayes' 0 0 -1 0 1 0 0 0 0;
  contrast 'AdjU vs Clop'  0 0 -1 0 0 1 0 0 0;
  contrast 'AdjU vs Logit' 0 0 -1 0 0 0 1 0 0;
  contrast 'AdjU vs Score' 0 0 -1 0 0 0 0 1 0;
  contrast 'AdjU vs Wald'  0 0 -1 0 0 0 0 0 1; 
/* */
  contrast 'Bork vs Bayes' 0 0 0 -1 1 0 0 0 0;  /* Method 4 vs Method 5 */
  contrast 'Bork vs Clop'  0 0 0 -1 0 1 0 0 0;
  contrast 'Bork vs Logit' 0 0 0 -1 0 0 1 0 0;
  contrast 'Bork vs Score' 0 0 0 -1 0 0 0 1 0;
  contrast 'Bork vs Wald'  0 0 0 -1 0 0 0 0 1; 
/* */
  contrast 'Bayes vs Clop'  0 0 0 0 -1 1 0 0 0;
  contrast 'Bayes vs Logit' 0 0 0 0 -1 0 1 0 0;
  contrast 'Bayes vs Score' 0 0 0 0 -1 0 0 1 0;
  contrast 'Bayes vs Wald'  0 0 0 0 -1 0 0 0 1; 
/* */
  contrast 'Clop vs Logit'  0 0 0 0 0 -1 1 0 0;
  contrast 'Clop vs Score'  0 0 0 0 0 -1 0 1 0;
  contrast 'Clop vs Wald'   0 0 0 0 0 -1 0 0 1; 
/* */
  contrast 'Logit vs Score' 0 0 0 0 0 0 -1 1 0;
  contrast 'Logit vs Wald'  0 0 0 0 0 0 -1 0 1; 
/* */
  contrast 'Score vs Wald'  0 0 0 0 0 0 0 -1 1; /* Method 8 vs Method 9 */
run;
quit;
ods rtf close;

