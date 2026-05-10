/1
GO

CREATE TABLE Post (
    PostID INT PRIMARY KEY IDENTITY(1,1),
    PostName NVARCHAR(50) NOT NULL UNIQUE,
    BaseRate DECIMAL(10, 2) NOT NULL CHECK (BaseRate > 0)
);

CREATE TABLE Qualification (
    QualID INT PRIMARY KEY IDENTITY(1,1),
    QualName NVARCHAR(50) NOT NULL UNIQUE,
    AllowanceFactor DECIMAL(5, 2) NOT NULL DEFAULT 1.0 CHECK (AllowanceFactor >= 1)
);

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName NVARCHAR(100) NOT NULL,
    ContactPerson NVARCHAR(100),
    Phone NVARCHAR(20) NOT NULL CHECK (Phone LIKE '+%')
);

CREATE TABLE Project (
    ProjectID INT PRIMARY KEY IDENTITY(1,1),
    ProjectName NVARCHAR(100) NOT NULL,
    CustomerID INT NOT NULL,
    ManagerName NVARCHAR(100) NOT NULL,
    PlannedDurationDays INT NOT NULL CHECK (PlannedDurationDays > 0),
    DifficultyCategory NVARCHAR(20) NOT NULL,
    StartDate DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Performer (
    PerformerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    PostID INT NOT NULL,
    QualID INT NOT NULL,
    FOREIGN KEY (PostID) REFERENCES Post(PostID),
    FOREIGN KEY (QualID) REFERENCES Qualification(QualID)
);


CREATE TABLE WorkReport (
    ReportID INT PRIMARY KEY IDENTITY(1,1),
    PerformerID INT NOT NULL,
    ProjectID INT NOT NULL,
    ReportDate DATE NOT NULL,
    WorkDescription NVARCHAR(MAX),
    HoursWorked INT NOT NULL CHECK (HoursWorked > 0 AND HoursWorked <= 10),
    FOREIGN KEY (PerformerID) REFERENCES Performer(PerformerID),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);

CREATE TABLE Account (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    ProjectID INT NOT NULL,
    BillingMonth DATE NOT NULL,
    TotalAmount DECIMAL(15, 2) NOT NULL,
    IsPaid BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProjectID) REFERENCES Project(ProjectID)
);
GO

INSERT INTO Post (PostName, BaseRate) VALUES 
(N'Backend Developer', 650.00),
(N'Frontend Developer', 600.00),
(N'UI/UX Designer', 500.00),
(N'Project Manager', 800.00),
(N'QA Engineer', 450.00),
(N'DevOps Engineer', 750.00),
(N'Business Analyst', 700.00);

INSERT INTO Qualification (QualName, AllowanceFactor) VALUES 
(N'Junior', 1.00),
(N'Middle', 1.30),
(N'Senior', 1.60),
(N'Lead', 2.00);

INSERT INTO Customer (CustomerName, ContactPerson, Phone) VALUES 
(N'TechSolutions UA', N'Олексій Петренко', '+380671112233'),
(N'Global Retail', N'Марія Іванова', '+380504445566'),
(N'Lviv Startup Hub', N'Андрій Сидор', '+380937778899'),
(N'AgroSoft', N'Дмитро Козак', '+380671234567'),
(N'E-Learning Systems', N'Олена Кравченко', '+380509876543');

INSERT INTO Project (ProjectName, CustomerID, ManagerName, PlannedDurationDays, DifficultyCategory, StartDate) VALUES 
(N'E-Commerce Platform', 2, N'Анна Коваль', 120, N'High', '2024-01-10'),
(N'CRM System Update', 1, N'Анна Коваль', 45, N'Medium', '2024-02-15'),
(N'Mobile App Design', 3, N'Олена Вітвицька', 30, N'Light', '2024-03-01'),
(N'Agro-Monitoring Tool', 4, N'Микола Романів', 180, N'High', '2024-03-10'),
(N'Student Portal', 5, N'Анна Коваль', 90, N'Medium', '2024-04-01');

INSERT INTO Performer (FullName, PostID, QualID) VALUES 
(N'Дмитро Слюсарчук', 1, 2), -- Middle Backend
(N'Олена Вітвицька', 3, 3),  -- Senior Designer
(N'Микола Романів', 5, 1),   -- Junior QA
(N'Анна Коваль', 4, 4),      -- Lead PM
(N'Олександр Чорний', 1, 3), -- Senior Backend
(N'Марина Кравчук', 2, 2),   -- Middle Frontend
(N'Ігор Шевченко', 6, 3),    -- Senior DevOps
(N'Тетяна Сорока', 7, 2);    -- Middle BA


INSERT INTO WorkReport (PerformerID, ProjectID, ReportDate, WorkDescription, HoursWorked) VALUES 
(1, 1, '2024-01-11', N'Налаштування бази даних', 8),
(5, 1, '2024-01-11', N'Архітектура мікросервісів', 10),
(6, 1, '2024-01-12', N'Верстка головної сторінки', 7),
(8, 1, '2024-01-12', N'Збір вимог до кошика', 6),
(1, 1, '2024-01-13', N'Інтеграція платіжних систем', 8),
(7, 1, '2024-01-14', N'CI/CD пайплайни', 5),

(1, 2, '2024-02-16', N'Розробка модуля авторизації', 8),
(1, 2, '2024-02-17', N'Тестування API', 4),
(1, 2, '2024-02-18', N'Робота з логами', 6),
(1, 2, '2024-02-19', N'Оптимізація запитів', 9),
(3, 2, '2024-02-20', N'Написання автотестів', 8),

(5, 4, '2024-03-15', N'Інтеграція з IoT датчиками', 10),
(7, 4, '2024-03-15', N'Налаштування серверів обробки', 6),
(1, 4, '2024-03-16', N'Алгоритми аналізу ґрунту', 8),
(6, 4, '2024-03-17', N'Візуалізація карт', 9);

INSERT INTO Account (ProjectID, BillingMonth, TotalAmount, IsPaid, CreatedAt) VALUES 
(1, '2024-01-01', 120500.00, 1, '2024-01-31'),
(1, '2024-02-01', 98000.00, 1, '2024-02-28'),
(2, '2024-02-01', 45000.00, 1, '2024-02-28'),
(2, '2024-03-01', 32000.00, 0, '2024-03-31'), 
(4, '2024-03-01', 75000.00, 0, '2024-03-31'), 
(3, '2024-03-01', 15000.00, 1, '2024-03-25');
GO
/2
-- 1. SELECT на базі однієї таблиці (сортування, OR та AND)
-- Знайти посади з базовою ставкою від 500 до 700 або посади менеджерів, сортувати за ставкою
SELECT * FROM Post
WHERE (BaseRate >= 500 AND BaseRate <= 700) OR PostName LIKE '%Manager%'
ORDER BY BaseRate DESC;

-- 2. SELECT з виводом обчислюваних полів
-- Розрахунок фактичної вартості години виконавця (ставка * коефіцієнт кваліфікації)
SELECT FullName, 
       (p.BaseRate * q.AllowanceFactor) AS HourlyCost
FROM Performer pf
JOIN Post p ON pf.PostID = p.PostID
JOIN Qualification q ON pf.QualID = q.QualID;

-- 3. SELECT на базі кількох таблиць (сортування, OR та AND)
-- Звіти про роботу над "High" або "Medium" проектами з сортуванням за датою
SELECT pr.ProjectName, pf.FullName, wr.HoursWorked, wr.ReportDate
FROM WorkReport wr
JOIN Project pr ON wr.ProjectID = pr.ProjectID
JOIN Performer pf ON wr.PerformerID = pf.PerformerID
WHERE (pr.DifficultyCategory = 'High' OR pr.DifficultyCategory = 'Medium')
  AND wr.HoursWorked > 5
ORDER BY wr.ReportDate;

-- 4. SELECT на базі кількох таблиць з типом поєднання Outer Join
-- Вивести всіх клієнтів та їхні проекти (навіть якщо проектів ще немає)
SELECT c.CustomerName, p.ProjectName
FROM Customer c
LEFT OUTER JOIN Project p ON c.CustomerID = p.CustomerID;

-- 5. SELECT з використанням Like, Between, In, Exists, All, Any
-- Вибрати проекти з певною тривалістю, де є оплачені рахунки
SELECT ProjectName FROM Project pr
WHERE PlannedDurationDays BETWEEN 30 AND 150
  AND DifficultyCategory IN ('High', 'Medium')
  AND EXISTS (SELECT 1 FROM Account a WHERE a.ProjectID = pr.ProjectID AND a.IsPaid = 1);

-- 6. SELECT з використанням підсумовування та групування
-- Загальна кількість годин по кожному проекту
SELECT p.ProjectName, SUM(wr.HoursWorked) AS TotalHours, COUNT(wr.ReportID) AS ReportsCount
FROM Project p
JOIN WorkReport wr ON p.ProjectID = wr.ProjectID
GROUP BY p.ProjectName;

-- 7. SELECT з використанням під-запитів в частині Where
-- Знайти виконавців, які працювали над проектами менеджера 'Анна Коваль'
SELECT DISTINCT FullName FROM Performer
WHERE PerformerID IN (
    SELECT PerformerID FROM WorkReport 
    WHERE ProjectID IN (SELECT ProjectID FROM Project WHERE ManagerName = N'Анна Коваль')
);

-- 8. SELECT з використанням під-запитів в частині From
-- Знайти проекти, де середня кількість годин у звіті більша за 7
SELECT T.ProjectName, T.AvgHours
FROM (
    SELECT p.ProjectName, AVG(CAST(wr.HoursWorked AS FLOAT)) AS AvgHours
    FROM Project p
    JOIN WorkReport wr ON p.ProjectID = wr.ProjectID
    GROUP BY p.ProjectName
) AS T
WHERE T.AvgHours > 7;

-- 9. Ієрархічний SELECT-запит (Логіка: Клієнт -> Проект)
SELECT 
    CustomerName AS Parent,
    ProjectName AS Child,
    'Project' AS Level
FROM Customer c
JOIN Project p ON c.CustomerID = p.CustomerID;

-- 10. SELECT-запит типу CrossTab (Pivot)
-- Кількість годин за категоріями складності в розрізі місяців (спрощено)
SELECT ProjectName, [1] AS Jan, [2] AS Feb, [3] AS Mar
FROM (
    SELECT ProjectName, MONTH(ReportDate) as RMonth, HoursWorked FROM WorkReport wr
    JOIN Project p ON wr.ProjectID = p.ProjectID
) AS Source
PIVOT (SUM(HoursWorked) FOR RMonth IN ([1], [2], [3])) AS PivotTable;

-- 11. UPDATE на базі однієї таблиці
-- Підняти базову ставку для QA
UPDATE Post SET BaseRate = BaseRate + 50 WHERE PostName = N'QA Engineer';

-- 12. UPDATE на базі кількох таблиць
-- Позначити рахунки як оплачені для всіх проектів певної складності
UPDATE Account
SET IsPaid = 1
FROM Account a
JOIN Project p ON a.ProjectID = p.ProjectID
WHERE p.DifficultyCategory = 'Light';

-- 13. Append (INSERT) з явно вказаними значеннями
INSERT INTO Customer (CustomerName, ContactPerson, Phone)
VALUES (N'New Tech Systems', N'Іван Іванов', '+380441112233');

-- 14. Append (INSERT) з інших таблиць
-- Створити архівну або допоміжну таблицю (для прикладу додамо в Performer нового ліда на базі існуючого)
INSERT INTO Performer (FullName, PostID, QualID)
SELECT FullName + N' (Copy)', PostID, QualID FROM Performer WHERE PerformerID = 4;

-- 15. DELETE для видалення вибраних записів
DELETE FROM WorkReport WHERE HoursWorked < 6;
/3
GO

CREATE PROCEDURE sp_CalculateSalaryForPerformer
    @PerformerID INT,
    @Year INT,
    @Month INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalHours INT;
    DECLARE @FullName NVARCHAR(100);
    DECLARE @HourlyRate DECIMAL(10, 2);
    DECLARE @TotalSalary DECIMAL(15, 2);

    -- Отримуємо дані працівника та його погодинну ставку
    SELECT 
        @FullName = pf.FullName,
        @HourlyRate = p.BaseRate * q.AllowanceFactor
    FROM Performer pf
    JOIN Post p ON pf.PostID = p.PostID
    JOIN Qualification q ON pf.QualID = q.QualID
    WHERE pf.PerformerID = @PerformerID;

    -- Рахуємо години за вказаний період
    SELECT @TotalHours = SUM(HoursWorked)
    FROM WorkReport
    WHERE PerformerID = @PerformerID 
      AND YEAR(ReportDate) = @Year 
      AND MONTH(ReportDate) = @Month;

    SET @TotalHours = ISNULL(@TotalHours, 0);
    SET @TotalSalary = @TotalHours * @HourlyRate;

    -- Виводимо результат у консоль
    IF @TotalHours > 0
    BEGIN
        PRINT N'Працівник: ' + @FullName + 
              N' | Період: ' + CAST(@Month AS NVARCHAR) + '/' + CAST(@Year AS NVARCHAR) +
              N' | Годин: ' + CAST(@TotalHours AS NVARCHAR) + 
              N' | До виплати: ' + CAST(@TotalSalary AS NVARCHAR) + N' грн.';
    END
    ELSE
    BEGIN
        PRINT N'Працівник: ' + @FullName + N' | Немає відпрацьованих годин у цьому місяці.';
    END
END;
GO

CREATE PROCEDURE sp_CalculateAllSalaries
    @Year INT,
    @Month INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CurrentID INT;

    PRINT N'--- ВІДОМІСТЬ НАРАХУВАННЯ ЗАРПЛАТИ ЗА ' + CAST(@Month AS NVARCHAR) + '/' + CAST(@Year AS NVARCHAR) + N' ---';
    PRINT '----------------------------------------------------------------------';

    -- Використовуємо курсор для ітерації по таблиці виконавців
    DECLARE PerformerCursor CURSOR FOR 
    SELECT PerformerID FROM Performer;

    OPEN PerformerCursor;
    FETCH NEXT FROM PerformerCursor INTO @CurrentID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Викликаємо розрахунок для поточного ID
        EXEC sp_CalculateSalaryForPerformer @PerformerID = @CurrentID, @Year = @Year, @Month = @Month;

        FETCH NEXT FROM PerformerCursor INTO @CurrentID;
    END;

    CLOSE PerformerCursor;
    DEALLOCATE PerformerCursor;

    PRINT '----------------------------------------------------------------------';
END;
GO

EXEC sp_CalculateSalaryForPerformer @PerformerID = 1, @Year = 2024, @Month = 1;

EXEC sp_CalculateAllSalaries @Year = 2024, @Month = 1;

/4
GO
-- Приклад для таблиць (повторити для всіх: Post, Qualification, Customer, Project, Performer, WorkReport, Account)
ALTER TABLE Post ADD UCR NVARCHAR(100), DCR DATETIME, ULC NVARCHAR(100), DLC DATETIME;
ALTER TABLE Qualification ADD UCR NVARCHAR(100), DCR DATETIME, ULC NVARCHAR(100), DLC DATETIME;
ALTER TABLE Customer ADD UCR NVARCHAR(100), DCR DATETIME, ULC NVARCHAR(100), DLC DATETIME;
ALTER TABLE Project ADD UCR NVARCHAR(100), DCR DATETIME, ULC NVARCHAR(100), DLC DATETIME;
ALTER TABLE Performer ADD UCR NVARCHAR(100), DCR DATETIME, ULC NVARCHAR(100), DLC DATETIME;
ALTER TABLE WorkReport ADD UCR NVARCHAR(100), DCR DATETIME, ULC NVARCHAR(100), DLC DATETIME;
ALTER TABLE Account ADD UCR NVARCHAR(100), DCR DATETIME, ULC NVARCHAR(100), DLC DATETIME;
GO
-- Список таблиць: Post, Qualification, Customer, Project, Performer, WorkReport, Account

-- 1. Таблиця Post
CREATE TRIGGER trg_Post_Audit ON Post AFTER INSERT, UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM inserted) AND NOT EXISTS(SELECT 1 FROM deleted)
        UPDATE Post SET UCR = SYSTEM_USER, DCR = GETDATE(), ULC = SYSTEM_USER, DLC = GETDATE()
        FROM Post t JOIN inserted i ON t.PostID = i.PostID;
    ELSE
        UPDATE Post SET ULC = SYSTEM_USER, DLC = GETDATE()
        FROM Post t JOIN inserted i ON t.PostID = i.PostID;
END;
GO

-- 2. Таблиця Qualification
CREATE TRIGGER trg_Qual_Audit ON Qualification AFTER INSERT, UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM inserted) AND NOT EXISTS(SELECT 1 FROM deleted)
        UPDATE Qualification SET UCR = SYSTEM_USER, DCR = GETDATE(), ULC = SYSTEM_USER, DLC = GETDATE()
        FROM Qualification t JOIN inserted i ON t.QualID = i.QualID;
    ELSE
        UPDATE Qualification SET ULC = SYSTEM_USER, DLC = GETDATE()
        FROM Qualification t JOIN inserted i ON t.QualID = i.QualID;
END;
GO

-- 3. Таблиця Customer
CREATE TRIGGER trg_Cust_Audit ON Customer AFTER INSERT, UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM inserted) AND NOT EXISTS(SELECT 1 FROM deleted)
        UPDATE Customer SET UCR = SYSTEM_USER, DCR = GETDATE(), ULC = SYSTEM_USER, DLC = GETDATE()
        FROM Customer t JOIN inserted i ON t.CustomerID = i.CustomerID;
    ELSE
        UPDATE Customer SET ULC = SYSTEM_USER, DLC = GETDATE()
        FROM Customer t JOIN inserted i ON t.CustomerID = i.CustomerID;
END;
GO

-- 4. Таблиця Project (Audit + Перевірка боргів замовника)
CREATE TRIGGER trg_Proj_Audit_Logic ON Project AFTER INSERT, UPDATE AS
BEGIN
    SET NOCOUNT ON;
    -- Аудит
    IF EXISTS(SELECT 1 FROM inserted) AND NOT EXISTS(SELECT 1 FROM deleted)
        UPDATE Project SET UCR = SYSTEM_USER, DCR = GETDATE(), ULC = SYSTEM_USER, DLC = GETDATE()
        FROM Project t JOIN inserted i ON t.ProjectID = i.ProjectID;
    ELSE
        UPDATE Project SET ULC = SYSTEM_USER, DLC = GETDATE()
        FROM Project t JOIN inserted i ON t.ProjectID = i.ProjectID;

    -- БІЗНЕС-ЛОГІКА: Перевірка неоплачених проектів (> 3 місяців)
    IF EXISTS (
        SELECT 1 FROM inserted i
        JOIN Project p ON i.CustomerID = p.CustomerID
        JOIN Account a ON p.ProjectID = a.ProjectID
        WHERE a.IsPaid = 0 AND DATEDIFF(MONTH, a.BillingMonth, GETDATE()) >= 3
    )
    BEGIN
        RAISERROR (N'Замовник має борги понад 3 місяці! Створення проекту відхилено.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- 5. Таблиця Performer
CREATE TRIGGER trg_Perf_Audit ON Performer AFTER INSERT, UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM inserted) AND NOT EXISTS(SELECT 1 FROM deleted)
        UPDATE Performer SET UCR = SYSTEM_USER, DCR = GETDATE(), ULC = SYSTEM_USER, DLC = GETDATE()
        FROM Performer t JOIN inserted i ON t.PerformerID = i.PerformerID;
    ELSE
        UPDATE Performer SET ULC = SYSTEM_USER, DLC = GETDATE()
        FROM Performer t JOIN inserted i ON t.PerformerID = i.PerformerID;
END;
GO

-- 6. Таблиця WorkReport (Audit + Обмеження 10 годин)
CREATE TRIGGER trg_Work_Audit_Logic ON WorkReport AFTER INSERT, UPDATE AS
BEGIN
    SET NOCOUNT ON;
    -- Аудит
    IF EXISTS(SELECT 1 FROM inserted) AND NOT EXISTS(SELECT 1 FROM deleted)
        UPDATE WorkReport SET UCR = SYSTEM_USER, DCR = GETDATE(), ULC = SYSTEM_USER, DLC = GETDATE()
        FROM WorkReport t JOIN inserted i ON t.ReportID = i.ReportID;
    ELSE
        UPDATE WorkReport SET ULC = SYSTEM_USER, DLC = GETDATE()
        FROM WorkReport t JOIN inserted i ON t.ReportID = i.ReportID;

    -- БІЗНЕС-ЛОГІКА: Обмеження 10 годин на день сумарно
    IF EXISTS (
        SELECT 1 FROM WorkReport wr
        WHERE wr.PerformerID IN (SELECT PerformerID FROM inserted)
        GROUP BY wr.PerformerID, wr.ReportDate
        HAVING SUM(wr.HoursWorked) > 10
    )
    BEGIN
        RAISERROR (N'Перевищено ліміт 10 робочих годин на добу для одного виконавця.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- 7. Таблиця Account
CREATE TRIGGER trg_Acc_Audit ON Account AFTER INSERT, UPDATE AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM inserted) AND NOT EXISTS(SELECT 1 FROM deleted)
        UPDATE Account SET UCR = SYSTEM_USER, DCR = GETDATE(), ULC = SYSTEM_USER, DLC = GETDATE()
        FROM Account t JOIN inserted i ON t.AccountID = i.AccountID;
    ELSE
        UPDATE Account SET ULC = SYSTEM_USER, DLC = GETDATE()
        FROM Account t JOIN inserted i ON t.AccountID = i.AccountID;
END;
GO

CREATE TABLE ProjectLogs (
    LogID INT PRIMARY KEY, -- Сурогатний ключ заповнюється тригером
    LogMessage NVARCHAR(MAX),
    LogDate DATETIME
);
GO

CREATE TRIGGER trg_ProjectLogs_Key ON ProjectLogs INSTEAD OF INSERT AS
BEGIN
    DECLARE @NextID INT = ISNULL((SELECT MAX(LogID) FROM ProjectLogs), 0);
    
    INSERT INTO ProjectLogs (LogID, LogMessage, LogDate)
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + @NextID, LogMessage, GETDATE()
    FROM inserted;
END;
GO


INSERT INTO Post (PostName, BaseRate) VALUES (N'Data Scientist', 900.00);

SELECT PostName, UCR, DCR, ULC, DLC FROM Post WHERE PostName = N'Data Scientist';

UPDATE Post SET BaseRate = 950.00 WHERE PostName = N'Data Scientist';

SELECT PostName, UCR, DCR, ULC, DLC FROM Post WHERE PostName = N'Data Scientist';

INSERT INTO ProjectLogs (LogMessage) VALUES (N'Перший лог системи');
INSERT INTO ProjectLogs (LogMessage) VALUES (N'Другий лог системи');

SELECT * FROM ProjectLogs;

INSERT INTO WorkReport (PerformerID, ProjectID, ReportDate, WorkDescription, HoursWorked)
VALUES (1, 1, '2026-05-10', N'Частина завдання А', 6);

INSERT INTO WorkReport (PerformerID, ProjectID, ReportDate, WorkDescription, HoursWorked)
VALUES (1, 1, '2026-05-10', N'Частина завдання Б', 5);

INSERT INTO Account (ProjectID, BillingMonth, TotalAmount, IsPaid)
VALUES (1, '2024-01-01', 5000.00, 0);

INSERT INTO Project (ProjectName, CustomerID, ManagerName, PlannedDurationDays, DifficultyCategory, StartDate)
VALUES (N'Заборонений Проект', 2, N'Анна Коваль', 30, N'Light', GETDATE());

GO
/5
-- Створення логінів на рівні сервера
CREATE LOGIN Ivan_PM WITH PASSWORD = 'StrongPassword123!';
CREATE LOGIN Olga_Accountant WITH PASSWORD = 'StrongPassword123!';
CREATE LOGIN Dmitry_Dev WITH PASSWORD = 'StrongPassword123!';

-- Створення користувачів на рівні бази даних
CREATE USER Ivan_PM FOR LOGIN Ivan_PM;
CREATE USER Olga_Accountant FOR LOGIN Olga_Accountant;
CREATE USER Dmitry_Dev FOR LOGIN Dmitry_Dev;
GO

-- Створення ролей
CREATE ROLE ProjectController;
CREATE ROLE FinancialOfficer;
GO

-- Роль ProjectController: доступ до проектів та виконавців
GRANT SELECT, INSERT, UPDATE ON Project TO ProjectController;
GRANT SELECT ON Performer TO ProjectController;
GRANT SELECT ON WorkReport TO ProjectController;

-- Роль FinancialOfficer: повний доступ до рахунків
GRANT SELECT, INSERT, UPDATE ON Account TO FinancialOfficer;
GRANT SELECT ON Project TO FinancialOfficer;
GO

-- Розробник Dmitry_Dev може лише вставляти звіти та бачити проекти
GRANT SELECT ON Project TO Dmitry_Dev;
GRANT INSERT ON WorkReport TO Dmitry_Dev;
-- Надамо персонально право на SELECT для Post, яке потім будемо тестувати
GRANT SELECT ON Post TO Dmitry_Dev;
GO

-- Іван отримує роль контролера проектів
ALTER ROLE ProjectController ADD MEMBER Ivan_PM;

-- Ольга отримує фінансову роль
ALTER ROLE FinancialOfficer ADD MEMBER Olga_Accountant;

-- Дмитро отримує роль контролера проектів (наприклад, для перегляду)
ALTER ROLE ProjectController ADD MEMBER Dmitry_Dev;
GO

REVOKE SELECT ON Project FROM Ivan_PM;
-- Результат: Ivan_PM все ще має доступ через роль ProjectController.

-- Відкликаємо роль
ALTER ROLE ProjectController DROP MEMBER Dmitry_Dev;

-- Перевірка:
-- SELECT * FROM Post; -- ПРАЦЮЄ (персональне право)
-- SELECT * FROM WorkReport; -- ПОМИЛКА (права через роль більше немає)


-- Видаляємо членів ролей (якщо залишилися) перед видаленням ролі
ALTER ROLE ProjectController DROP MEMBER Ivan_PM;
ALTER ROLE FinancialOfficer DROP MEMBER Olga_Accountant;

-- Видаляємо ролі
DROP ROLE ProjectController;
DROP ROLE FinancialOfficer;

-- Видаляємо користувачів бази даних
DROP USER Ivan_PM;
DROP USER Olga_Accountant;
DROP USER Dmitry_Dev;

-- Видаляємо логіни сервера
DROP LOGIN Ivan_PM;
DROP LOGIN Olga_Accountant;
DROP LOGIN Dmitry_Dev;
GO


-----------------------------------------------------------
-- ТЕСТУВАННЯ КОРИСТУВАЧА Ivan_PM (Role: ProjectController)
-----------------------------------------------------------
PRINT '--- Тестування Ivan_PM ---';
EXECUTE AS USER = 'Ivan_PM';

-- Має працювати (права через роль)
SELECT * FROM Project;
SELECT * FROM Performer;

-- Має видати ПОМИЛКУ (немає прав на фінанси)
-- SELECT * FROM Account; 

REVERT;
GO

-----------------------------------------------------------
-- ТЕСТУВАННЯ КОРИСТУВАЧА Olga_Accountant (Role: FinancialOfficer)
-----------------------------------------------------------
PRINT '--- Тестування Olga_Accountant ---';
EXECUTE AS USER = 'Olga_Accountant';

-- Має працювати (права на фінанси та перегляд проектів)
SELECT * FROM Account;
SELECT * FROM Project;

-- Має видати ПОМИЛКУ (немає прав на довідник посад)
-- SELECT * FROM Post; 

REVERT;
GO

-----------------------------------------------------------
-- ТЕСТУВАННЯ КОРИСТУВАЧА Dmitry_Dev (Personal Rights)
-----------------------------------------------------------
PRINT '--- Тестування Dmitry_Dev ---';
EXECUTE AS USER = 'Dmitry_Dev';

-- Має працювати (персональне право на перегляд проектів)
SELECT * FROM Project;

-- Має працювати (право на вставку звітів)
INSERT INTO WorkReport (PerformerID, ProjectID, ReportDate, WorkDescription, HoursWorked)
VALUES (1, 1, GETDATE(), N'Тестовий звіт від розробника', 4);

-- Має видати ПОМИЛКУ (немає прав на видалення)
-- DELETE FROM Project;

REVERT;
GO

-----------------------------------------------------------
-- ТЕСТУВАННЯ ВІДКЛИКАННЯ ПРАВ (Пункти 6-7 завдання)
-----------------------------------------------------------

-- 1. Перевірка Ivan_PM після REVOKE персонального права, але при наявності ролі
EXECUTE AS USER = 'Ivan_PM';
PRINT '--- Тест Ivan_PM після REVOKE (має працювати через роль) ---';
SELECT * FROM Project; -- ПРАЦЮЄ, бо роль ProjectController все ще має GRANT
REVERT;
GO

-- 2. Перевірка Dmitry_Dev після видалення з ролі
-- (Перед цим виконайте: ALTER ROLE ProjectController DROP MEMBER Dmitry_Dev;)
EXECUTE AS USER = 'Dmitry_Dev';
PRINT '--- Тест Dmitry_Dev після видалення з ролі ---';

-- SELECT * FROM Performer; -- МАЄ ВИДАТИ ПОМИЛКУ (право було лише в ролі)
SELECT * FROM Post;      -- ПРАЦЮЄ (це було персональне право)

REVERT;
GO