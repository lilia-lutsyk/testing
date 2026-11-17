using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using NUnit.Framework;
using CalcClassBr; 

namespace Testing1
{
    [TestFixture]
    public class Tests
    {
        private static readonly string connectionString =
            @"Server=DESKTOP-21RFT4C;Database=lab1;Trusted_Connection=True;";

        public static IEnumerable<TestCaseData> GetDbTestData()
        {
            string query = "SELECT ParamA, ParamB, ExpectedResult, ExpectedError FROM MultTestData";

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand(query, conn))
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        long a = Convert.ToInt64(reader["ParamA"]);
                        long b = Convert.ToInt64(reader["ParamB"]);
                        int expectedResult = Convert.ToInt32(reader["ExpectedResult"]);
                        string expectedError = reader["ExpectedError"].ToString();

                        yield return new TestCaseData(a, b, expectedResult, expectedError);
                    }
                }
            }
        }

        [Test]
        [TestCaseSource(nameof(GetDbTestData))]
        public void Mult_DataDrivenTest(long a, long b, int expectedResult, string expectedError)
        {
            if (string.IsNullOrEmpty(expectedError))
            {
                int actualResult = CalcClass.Mult(a, b);
                Assert.That(actualResult, Is.EqualTo(expectedResult), $"Помилка для {a} * {b}");
            }
            else
            {
                var ex = Assert.Throws<ArgumentOutOfRangeException>(() => CalcClass.Mult(a, b));

                string errorCode = expectedError.Length >= 8 ? expectedError.Substring(0, 8) : expectedError;

                Assert.That(ex.ParamName ?? ex.Message, Does.Contain(errorCode),
                    $"Очікувалася помилка з кодом '{errorCode}' для {a} * {b}");
            }
        }
    }
}