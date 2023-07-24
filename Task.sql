CREATE DATABASE Task
USE Task
CREATE TABLE Groups (
	Id INT PRIMARY KEY IDENTITY,
	[No] VARCHAR(5) UNIQUE NOT NULL
)
CREATE TABLE Students (
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(20) NOT NULL,
	LastName NVARCHAR(20) NOT NULL,
	GroupId INT FOREIGN KEY REFERENCES Groups(Id)
)
CREATE TABLE Exams (
	Id INT PRIMARY KEY IDENTITY,
	SubjectName NVARCHAR(20) NOT NULL,
	StartDate SMALLDATETIME NOT NULL,
	EndDate SMALLDATETIME NOT NULL
)
CREATE TABLE StudentExams (
	StudentId INT FOREIGN KEY REFERENCES Students(Id),
	ExamId INT FOREIGN KEY REFERENCES Exams(Id),
	ResultPoint INT NOT NULL CHECK(ResultPoint <= 100 and ResultPoint >= 0)
)
INSERT INTO Groups VALUES ('P234'), ('P452'), ('P331')
INSERT INTO Students VALUES ('Nasrin', 'Asadli', 1),
	('Nilgun', 'Babazada', 1), ('Samira', 'Hajizada', 3),
	('Jabbar', 'Jabbarli', 2), ('Melisa', 'Mansimli', 3),
	('Maryam', 'Sahibova', 3), ('Bayram', 'Bayramov', 2)
INSERT INTO Exams VALUES
	('C# Intro', '04/27/2023 16:30:00', '04/27/2023 17:00:00'),
	('HTML/CSS', '06/01/2023 15:30:00', '06/01/2023 16:30:00'),
	('JavaScript', '07/23/2023 14:30:00', '07/23/2023 16:00:00')
INSERT INTO StudentExams VALUES
	(1, 1, 82), (1, 2, 100), (1, 3, 89), (2, 1, 75), (2, 2, 97), (2, 3, 85),
	(3, 2, 67), (3, 3, 56), (4, 1, 48), (5, 2, 70), (6, 1, 60), (6, 2, 71)

--1 Bütün Student dataları və hər bir Student datasının yanında oxuduğu qrupun No dəyəri
SELECT S.Id, S.FirstName, S.LastName, G.No AS 'Group No'
FROM Students S LEFT JOIN
Groups G ON S.GroupId = G.Id

--2 Bütün Student dataları və hər bir Student datasının yanında onun bütün imtahanlarının sayı
SELECT S.Id, S.FirstName, S.LastName, COUNT(SE.ExamId) 'Exams Count'
FROM Students S LEFT JOIN
StudentExams SE ON S.Id = SE.StudentId
GROUP BY S.Id, S.FirstName, S.LastName

--3 Dünən baş vermiş bütün Examlər və hər bir Exam datasının yanında studentlərinin sayı
SELECT E.Id, E.SubjectName, E.StartDate, E.EndDate, COUNT(SE.StudentId) 'Students Count'
FROM Exams E LEFT JOIN
StudentExams SE ON E.Id = SE.ExamId
WHERE DATEPART(DAY, E.StartDate) = DATEPART(DAY, DATEADD(day, -1, GETDATE()))
and DATEPART(MONTH, E.StartDate) = DATEPART(MONTH, DATEADD(day, -1, GETDATE()))
and DATEPART(YEAR, E.StartDate) = DATEPART(YEAR, DATEADD(day, -1, GETDATE()))
GROUP BY E.Id, E.SubjectName, E.StartDate, E.EndDate

--4 Bütün StudentExam dataları və hər bir StudentExam datasının yanında onun Studentinin adı və qrup nömrəsi
SELECT SE.StudentId, S.FirstName, S.LastName, Groups.No 'GroupNo', SE.ExamId, SE.ResultPoint
FROM StudentExams SE LEFT
JOIN Students S ON SE.StudentId = S.Id
JOIN Groups ON S.GroupId = Groups.Id

--5 Bütün Student dataları və hər bir Student datasının yanında onun bütün imtahanlarının ortalama result dəyəri
SELECT S.Id, S.FirstName, S.LastName, AVG(SE.ResultPoint) 'Average'
FROM Students S LEFT JOIN
StudentExams SE ON S.Id = SE.StudentId
GROUP BY S.Id, S.FirstName, S.LastName