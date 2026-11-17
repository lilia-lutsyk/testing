using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using TechTalk.SpecFlow;
using NUnit.Framework;
using Newtonsoft.Json.Linq;

namespace YourNamespace
{
    [Binding]
    public class DeleteBookingSteps
    {
        private HttpClient httpClient = new HttpClient();
        private HttpResponseMessage response;
        private string endpoint;

        [Given(@"the API endpoint for delete ""(.*)""")]
        public void GivenTheApiEndpoint(string url)
        {
            endpoint = url;
        }

        [When(@"I send a DELETE request with ID and a valid token")]
        public async Task WhenISendADELETERequestWithIDAndAValidToken()
        {
            // 1. Автоматична генерація токена, якщо CreateToken.token ще не був встановлений
            if (string.IsNullOrEmpty(CreateToken.token))
            {
                var authClient = new HttpClient();
                var authBody = "{\"username\" : \"admin\", \"password\" : \"password123\"}";
                var authRequest = new HttpRequestMessage(HttpMethod.Post, "https://restful-booker.herokuapp.com/auth")
                {
                    Content = new StringContent(authBody, Encoding.UTF8, "application/json")
                };

                var authResponse = await authClient.SendAsync(authRequest);
                var authContent = await authResponse.Content.ReadAsStringAsync();
                var json = JObject.Parse(authContent);
                CreateToken.token = json["token"]?.ToString();
            }

            // 2. Визначення URL: якщо в URL є {id}, підставляємо актуальний ID (або за замовчуванням "23")
            string finalUrl = endpoint;
            if (endpoint.Contains("{id}"))
            {
                string targetId = !string.IsNullOrEmpty(CreateBookingSteps.id) ? CreateBookingSteps.id : "23";
                finalUrl = endpoint.Replace("{id}", targetId);
            }

            // 3. Формування та відправка DELETE-запиту з додаванням Cookie-токена
            var request = new HttpRequestMessage(HttpMethod.Delete, finalUrl);
            request.Headers.Add("Cookie", $"token={CreateToken.token}");

            response = await httpClient.SendAsync(request);
        }

        [Then(@"the response status code should be 201")]
        public void ThenTheResponseStatusCodeShouldBe201()
        {
            Assert.AreEqual(201, (int)response.StatusCode, $"Очікувався код 201 Created, але отримано status code {response.StatusCode}");
        }

        [Then(@"the response for delete should contain ""Created""")]
        public async Task ThenTheResponseShouldContainOK()
        {
            if (response.IsSuccessStatusCode)
            {
                var content = await response.Content.ReadAsStringAsync();
                Assert.AreEqual("Created", content);
            }
            else
            {
                Assert.Fail($"Запит на видалення не був успішним. Отримано статус: {response.StatusCode}");
            }
        }
    }
}