using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using TechTalk.SpecFlow;

namespace YourProjectNamespace
{
    [Binding]
    public class LoginSteps
    {
        private IWebDriver driver;
        private LoginPage loginPage;

        public LoginSteps()
        {
            driver = new ChromeDriver();
            loginPage = new LoginPage(driver);
        }

        [Given(@"I am on the banking website")]
        public void GivenIAmOnTheBankingWebsite()
        {
            loginPage.OpenLoginPage("https://www.globalsqa.com/angularJs-protractor/BankingProject");
        }

        [When(@"I select ""Login as Bank Manager"" option")]
        public void WhenISelectLoginAsBankManagerOption()
        {
            loginPage.ClickLoginAsBankManager();
        }

        [When(@"I click ""Add Customer"" tab")]
        public void WhenIClickAddCustomerTab()
        {
            loginPage.ClickAddCustomerTab();
        }

        [When(@"I enter First Name ""(.*)"", Last Name ""(.*)"", and Post Code ""(.*)""")]
        public void WhenIEnterCustomerDetails(string firstName, string lastName, string postCode)
        {
            loginPage.EnterCustomerDetails(firstName, lastName, postCode);
        }

        [When(@"I click ""Add Customer"" submit button")]
        public void WhenIClickAddCustomerSubmitButton()
        {
            loginPage.SubmitAddCustomer();
        }

        [Then(@"I should see alert message containing ""(.*)""")]
        public void ThenIShouldSeeAlertMessageContaining(string expectedMessage)
        {
            string actualAlertText = loginPage.GetAlertText();
            Assert.IsTrue(actualAlertText.Contains(expectedMessage),
                $"Очікувалось повідомлення з: '{expectedMessage}', але отримано: '{actualAlertText}'");
        }

        [Then(@"I accept the alert")]
        public void ThenIAcceptTheAlert()
        {
            loginPage.AcceptAlert();
        }

        [Then(@"I should close Chrome")]
        public void CloseChrome()
        {
            loginPage.CloseDriver();
        }
    }
}