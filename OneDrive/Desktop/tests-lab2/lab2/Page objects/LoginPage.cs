using System;
using System.Threading;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using SeleniumExtras.WaitHelpers;

public class LoginPage
{
    private IWebDriver driver;
    private WebDriverWait wait;

    public LoginPage(IWebDriver driver)
    {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
    }

    // Відкриття головної сторінки
    public void OpenLoginPage(string url)
    {
        driver.Navigate().GoToUrl(url);
    }

    // Вхід як Bank Manager
    public void ClickLoginAsBankManager()
    {
        IWebElement loginButton = wait.Until(ExpectedConditions.ElementToBeClickable(By.XPath("//button[contains(text(),'Bank Manager Login')]")));
        loginButton.Click();
    }

    // Перехід на вкладку "Add Customer"
    public void ClickAddCustomerTab()
    {
        IWebElement addCustomerTab = wait.Until(ExpectedConditions.ElementToBeClickable(By.XPath("//button[contains(text(),'Add Customer')]")));
        addCustomerTab.Click();
    }

    // Введення даних у форму
    public void EnterCustomerDetails(string firstName, string lastName, string postCode)
    {
        IWebElement firstNameInput = wait.Until(ExpectedConditions.ElementIsVisible(By.XPath("//input[@placeholder='First Name']")));
        firstNameInput.Clear();
        firstNameInput.SendKeys(firstName);

        IWebElement lastNameInput = driver.FindElement(By.XPath("//input[@placeholder='Last Name']"));
        lastNameInput.Clear();
        lastNameInput.SendKeys(lastName);

        IWebElement postCodeInput = driver.FindElement(By.XPath("//input[@placeholder='Post Code']"));
        postCodeInput.Clear();
        postCodeInput.SendKeys(postCode);

        // Пауза 2 секунди, щоб побачити заповнену форму перед натисканням кнопки
        Thread.Sleep(TimeSpan.FromSeconds(2));
    }

    // Натискання кнопки підтвердження форми
    public void SubmitAddCustomer()
    {
        IWebElement submitBtn = driver.FindElement(By.XPath("//form//button[@type='submit']"));
        submitBtn.Click();
    }

    // Отримання тексту з модального вікна (Alert)
    public string GetAlertText()
    {
        IAlert alert = wait.Until(ExpectedConditions.AlertIsPresent());
        return alert.Text;
    }

    // Закриття Alert (натискання OK)
    public void AcceptAlert()
    {
        IAlert alert = driver.SwitchTo().Alert();

        // Пауза 3 секунди, поки алерт відкритий на екрані
        Thread.Sleep(TimeSpan.FromSeconds(3));

        alert.Accept();
    }

    // Закриття браузера
    public void CloseDriver()
    {
        // Додаткова пауза перед закриттям браузера
        Thread.Sleep(TimeSpan.FromSeconds(2));
        driver?.Quit();
    }
}