#!/usr/bin/env python
# coding: utf-8

# In[1]:


#Get loan amount, interest rate, and loan term from user


# In[2]:


loanAmount = int(input("""
Input the total amount of your loan:
(without a dollar sign or commas, i.e. 25000 or 325000)"""))
print()

interestRate = float(input("""
Input your interest rate:
(without a percent sign)"""))
print()

loanTerm = int(input("""
Input the term of your loan in years:"""))


# In[3]:


#Calculate adjusted variables


# In[4]:


monthlyInterest = (interestRate/100)/12
monthlyTerm = loanTerm * 12


# In[5]:


#Calculate estimated monthly loan payment


# In[6]:


estimatedLoanPayment = loanAmount * ((monthlyInterest * ((1 + monthlyInterest)**monthlyTerm)) / (((1 + monthlyInterest)**monthlyTerm)-1))


# In[7]:


formattedLoanPayment = '${:,.2f}'.format(estimatedLoanPayment)


# In[8]:


print('Your estimated monthly payment is ',formattedLoanPayment,'.')

