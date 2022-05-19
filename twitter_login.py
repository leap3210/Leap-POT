from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
import credentials
import time

driverLocation = r"C:\development\downloads\chromedriver_win32\chromedriver.exe"
driver = webdriver.Chrome(driverLocation)
 


driver.get("https://twitter.com/i/flow/login")

time.sleep(5)
username = driver.find_element_by_xpath('//input[@name="text"]')

username.send_keys(credentials.username)
print('username running')
username.send_keys(Keys.RETURN)
time.sleep(3)

password = driver.find_element_by_xpath('//input[@name="password"]')
print('password running')
time.sleep(2)

password.send_keys(credentials.password)
password.send_keys(Keys.RETURN)

twitterSpace = "https://twitter.com/i/spaces/1dRKZlOEzOQJB"
getTwitterSpace = driver.get(twitterSpace)
print('twitter space joined')
time.sleep(2)

driver.find_element(by=By.XPATH, value=f'//*[@id="react-root"]/div/div/div[2]/main/div/div/div/div/div/div[2]/div/div/div/div/div[4]/div/div').click()
print('space joined')
time.sleep(5)

driver.find_element(by=By.XPATH, value=f'//*[@id="animatedComponent"]/div/div/div/div[3]/div[2]/div').click()
#button clicked

time.sleep(4)
#div container of username elements
spaceUsers = driver.find_elements(by=By.XPATH, value=f'//*[@id="layers"]/div[2]/div/div/div/div/div[1]/div/div/div[2]/div/div')


userTime = []
userDict = {}



while 1:
    # We should check for an element that we expect to be on the page here to make sure we haven't timed out
    #   If we have timed out, redo the login function
    listOfNames = [] # List of names to store

    for i in range(2,1000): # Loop up to 1000 rows
        for j in range(1,5): # Loop up to 3 columns (3 show up in my browser)
            try:
                # Try to get the name and add it to the list
                name = driver.find_element(by=By.XPATH, value=f'/html/body/div[1]/div/div/div[1]/div/div[1]/div/div/div/div[1]/div/div/div[2]/div/div/div[' + str(i) + ']/div/div[' + str(j) + ']/div[2]/div/div/div/div/span[1]/span/span[1]').get_attribute('innerHTML')
                listOfNames.append(name)
            except:
                # If we hit an exception because it didn't exist then...
                i = 1001 # Set our counter variables so we leave the loops
                j = 4
                # here you would post the names I guess to the API, just printing for now
                for name in listOfNames:
                    if name in userDict.keys():
                        timeValue = userDict[name]
                        userDict[name] = timeValue + 1
                    else:
                        userDict[name] = 1

                print('\n\n')
                print(userDict)
                
                time.sleep(10) # sleep for some amount of time and check the page again for an updated list. Might have to reload?
                #driver.refresh()
                #time.sleep(5)
                #driver.find_element(by=By.XPATH, value=f'//*[@id="react-root"]/div/div/div[2]/main/div/div/div/div/div/div[2]/div/div/div/div/div[4]/div/div').click()


time.sleep(4)

#print(spaceJoin)
#WebDriverWait(driver, 20).until(EC.element_to_be_clickable((By.XPATH, "//*[@id='react-root'")))