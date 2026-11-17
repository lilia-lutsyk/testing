using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.SqlClient;
using NUnit.Framework;
using AnalaizerClassLibrary;

namespace AnalaizerClassLibrary.Tests
{
    [TestFixture]
    public class SeparateTests
    {
        // Рядок підключення до вашого MS SQL Server / Docker
        private static readonly string connectionString =
            @"Server=localhost,1433;Database=lab1;User Id=sa;Password=YourPassword123!;TrustServerCertificate=True;";

        // Метод підтягує тестові дані з бази SQL
        public static IEnumerable<TestCaseData> GetDbTestData()
        {
            string query = "SELECT Expression, ExpectedTokens, ExpectedError FROM Var10SeparateTestData";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(query, conn))
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        string expr = reader["Expression"].ToString();
                        string expectedTokens = reader["ExpectedTokens"]?.ToString() ?? "";
                        string expectedError = reader["ExpectedError"]?.ToString() ?? "";

                        yield return new TestCaseData(expr, expectedTokens, expectedError);
                    }
                }
            }
        }

        [Test]
        [TestCaseSource(nameof(GetDbTestData))]
        public void Test_Separate(string expression, string expectedTokens, string expectedError)
        {
            if (string.IsNullOrEmpty(expectedError))
            {
                // Позитивний сценарій: розбиття на токени
                ArrayList actualTokens = AnalaizerClass.Separate(expression);
                string result = string.Join(",", actualTokens.ToArray());

                Assert.That(result, Is.EqualTo(expectedTokens));
            }
            else
            {
                // Негативний сценарій: виняток із кодом помилки
                var ex = Assert.Throws<Exception>(() => AnalaizerClass.Separate(expression));
                Assert.That(ex.Message, Does.Contain(expectedError));
            }
        }
    }
}