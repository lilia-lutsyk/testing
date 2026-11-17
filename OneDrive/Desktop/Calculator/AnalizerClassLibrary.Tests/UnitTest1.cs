using Microsoft.Data.Sqlite;
using AnalaizerClassLibrary;
using NUnit.Framework;
using System.Collections.Generic;

namespace AnalizerClassLibrary.Tests;

public class SeparateTests
{
    private const string ConnectionString = "Data Source=separate_tests.db";

    [OneTimeSetUp]
    public void CreateDatabase()
    {
        using var connection = new SqliteConnection(ConnectionString);
        connection.Open();

        var createCommand = connection.CreateCommand();
        createCommand.CommandText = @"
            CREATE TABLE IF NOT EXISTS SeparateTestCases (
                Id INTEGER PRIMARY KEY AUTOINCREMENT,
                Input TEXT NOT NULL,
                Expected TEXT NOT NULL
            );
        ";
        createCommand.ExecuteNonQuery();

        var countCommand = connection.CreateCommand();
        countCommand.CommandText = "SELECT COUNT(*) FROM SeparateTestCases";

        long count = (long)countCommand.ExecuteScalar()!;

        if (count == 0)
        {
            string[,] testData =
            {
                { "123", "123" },
                { "12+34", "12|+|34" },
                { "abc123", "abc123" },
                { "abc+123", "abc|+|123" },
                { "(12+3)", "(|12|+|3|)" },
                { "10-5*2", "10|-|5|*|2" },
                { "20/4", "20|/|4" },
                { "test123", "test123" }
            };

            for (int i = 0; i < testData.GetLength(0); i++)
            {
                var insertCommand = connection.CreateCommand();

                insertCommand.CommandText = @"
                    INSERT INTO SeparateTestCases (Input, Expected)
                    VALUES ($input, $expected);
                ";

                insertCommand.Parameters.AddWithValue("$input", testData[i, 0]);
                insertCommand.Parameters.AddWithValue("$expected", testData[i, 1]);

                insertCommand.ExecuteNonQuery();
            }
        }
    }

    public static IEnumerable<TestCaseData> GetTestCases()
    {
        using var connection = new SqliteConnection(ConnectionString);
        connection.Open();

        var command = connection.CreateCommand();

        command.CommandText = @"
            SELECT Id, Input, Expected
            FROM SeparateTestCases
            ORDER BY Id;
        ";

        using var reader = command.ExecuteReader();

        while (reader.Read())
        {
            int id = reader.GetInt32(0);
            string input = reader.GetString(1);
            string expected = reader.GetString(2);

            yield return new TestCaseData(input, expected)
                .SetName($"Separate_Test_{id}_{input}");
        }
    }

    [TestCaseSource(nameof(GetTestCases))]
    public void Separate_ReturnsExpectedTokens(string input, string expected)
    {
        var result = AnalaizerClass.Separate(input);

        Assert.That(
            string.Join("|", result),
            Is.EqualTo(expected)
        );
    }
}