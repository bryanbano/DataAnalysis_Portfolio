#!/usr/bin/env python
# coding: utf-8

# In[1]:


import os,shutil


# In[2]:


path = r'/home/bryan/Desktop/Python Sorter/'


# In[3]:


#Create folders


# In[4]:


fileName = os.listdir(path)


# In[5]:


folderNames = ['csv files','image files','text files']

for createFolder in range(0,3):
    if not os.path.exists(path + folderNames[createFolder]):
        print(path + folderNames[createFolder])
        os.makedirs(path + folderNames[createFolder])


# In[6]:


#View files to determine type and move into new folder


# In[7]:


for file in fileName:
    if '.csv' in file and not os.path.exists(path + 'csv files/' + file):
        shutil.move(path + file, path + 'csv files/' + file)
    elif '.jpg' in file and not os.path.exists(path + 'image files/' + file):
        shutil.move(path + file, path + 'image files/' + file)
    elif '.txt' in file and not os.path.exists(path + 'text files/' + file):
        shutil.move(path + file, path + 'text files/' + file)

