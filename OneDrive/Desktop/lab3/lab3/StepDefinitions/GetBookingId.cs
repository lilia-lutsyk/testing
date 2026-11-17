using System;
using System.Collections.Generic;
using System.Net.Http;
using Newtonsoft.Json.Linq;
using NUnit.Framework;
using TechTalk.SpecFlow;

namespace YourNamespace
{
    [Binding]
    public class RetrieveBookingIDsSteps
    {
        private HttpClient httpClient = new HttpClient();
        private HttpResponseMessage response;
        private List<int> bookingIDs;

        [When(@"I send a GET request to ""(.*)""")]
        public void WhenISendAGETRequestTo(string url)
        {
            var request = new HttpRequestMessage(HttpMethod.Get, url);

            // Обов'язково додаємо заголовок Accept: application/json
            request.Headers.Accept.Add(new System.Net.Http.Headers.MediaTypeWithQualityHeaderValue("application/json"));

            response = httpClient.Send(request);
        }

        [Then(@"the response status code should be 200")]
        public void ThenTheResponseStatusCodeShouldBe200()
        {
            Assert.AreEqual(200, (int)response.StatusCode);
        }

        [Then(@"the response should contain booking IDs")]
        public void ThenTheResponseShouldContainBookingIDs()
        {
            if (response.IsSuccessStatusCode)
            {
                var content = response.Content.ReadAsStringAsync().Result;
                var jsonArray = Newtonsoft.Json.JsonConvert.DeserializeObject<JArray>(content);

                Assert.IsNotNull(jsonArray);

                bool containsBookingIDs = jsonArray.Any(item => item["bookingid"] != null);
                Assert.IsTrue(containsBookingIDs, "The response does not contain booking IDs.");
            }
            else
            {
                Assert.Fail("The request was not successful.");
            }
        }



        [Given(@"a booking with firstname ""(.*)""")]
        public void GivenABookingWithFirstname(string firstname)
        {
        }

        [When(@"I send a GET request with firstName to ""(.*)""")]
        public void WhenISendAGETRequestWithFirstNameTo(string url)
        {;
            response = httpClient.GetAsync(url).Result;
        }

        [Then(@"the response status code by firstName should be 200")]
        public void ThenTheResponseStatusCodeByFirstnameShouldBe200()
        {
            Assert.AreEqual(200, (int)response.StatusCode);
        }

        [Then(@"the response by firstName should contain booking IDs")]
        public void ThenTheResponseWithFirstnameShouldContainBookingIDs()
        {
            if (response.IsSuccessStatusCode)
            {
                var content = response.Content.ReadAsStringAsync().Result;
                var jsonArray = Newtonsoft.Json.JsonConvert.DeserializeObject<JArray>(content);

                Assert.IsNotNull(jsonArray);

                bool containsBookingIDs = jsonArray.Any(item => item["bookingid"] != null);
                Assert.IsTrue(containsBookingIDs, "The response does not contain booking IDs.");
            }
            else
            {
                Assert.Fail("The request was not successful.");
            }
        }

        [Given(@"a booking with checkin date ""(.*)"" and checkout date ""(.*)""")]
        public void GivenABookingWithCheckinDateAndCheckoutDate(string checkin, string checkout)
        {
        }

        [When(@"I send a GET request with data to ""(.*)""")]
        public void WhenISendAGETWithDataRequestTo(string url)
        {
            response = httpClient.GetAsync(url).Result;
        }

        [Then(@"the response status code by data should be 200")]
        public void ThenTheResponseStatusCodeWithDataShouldBe200()
        {
            Assert.AreEqual(200, (int)response.StatusCode);
        }

        [Then(@"the response by data should contain booking IDs")]
        public void ThenTheResponseByDataShouldContainBookingIDs()
        {
            if (response.IsSuccessStatusCode)
            {
                var content = response.Content.ReadAsStringAsync().Result;
                var jsonArray = Newtonsoft.Json.JsonConvert.DeserializeObject<JArray>(content);

                Assert.IsNotNull(jsonArray);

                bool containsBookingIDs = jsonArray.Any(item => item["bookingid"] != null);
                Assert.IsTrue(containsBookingIDs, "The response does not contain booking IDs.");
            }
            else
            {
                Assert.Fail("The request was not successful.");
            }
        }
        [Then(@"the response status code for specific ID should be 200")]
        public void ThenTheResponseStatusCodeForSpecificIDShouldBe200()
        {
            Assert.AreEqual(200, (int)response.StatusCode, $"Очікувався статус 200, але отримано {response.StatusCode}");
        }

        [Then(@"the response should contain booking details for ID (.*)")]
        public void ThenTheResponseShouldContainBookingDetailsForID(string bookingId)
        {
            if (response.IsSuccessStatusCode)
            {
                var content = response.Content.ReadAsStringAsync().Result;

                // Виводимо отриманий JSON у вікно Test Explorer Visual Studio
                Console.WriteLine($"====================================");
                Console.WriteLine($" ЗАПИТ ДЛЯ BOOKING ID: {bookingId}");
                Console.WriteLine($" ВІДПОВІДЬ СЕРВЕРА: {content}");
                Console.WriteLine($"====================================");

                Assert.IsFalse(string.IsNullOrEmpty(content), "Тіло відповіді порожнє.");
            }
            else
            {
                Assert.Fail($"Не вдалося отримати дані для ID: {bookingId}. Статус: {response.StatusCode}");
            }
        }
    }
}
