-- ملف: blog_demo_db.sql
-- وصف: قاعدة بيانات نموذجية لنظام مدونة مع بيانات جاهزة

-- إنشاء قاعدة البيانات
DROP DATABASE IF EXISTS blog_demo;
CREATE DATABASE blog_demo;
USE blog_demo;

-- جدول المستخدمين
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_admin BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- جدول المقالات
CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- جدول التعليقات
CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    content TEXT NOT NULL,
    user_id INT,
    post_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- جدول التصنيفات
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- جدول ربط بين المقالات والتصنيفات
CREATE TABLE post_category (
    post_id INT,
    category_id INT,
    PRIMARY KEY (post_id, category_id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- إدخال بيانات المستخدمين
INSERT INTO users (username, email, password, is_admin) VALUES
('admin', 'admin@blog.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
('ahmed', 'ahmed@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', FALSE),
('mohammed', 'mohammed@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', FALSE),
('sara', 'sara@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', FALSE),
('ali', 'ali@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', FALSE);

-- إدخال التصنيفات
INSERT INTO categories (name, description) VALUES
('Technology', 'Articles about technology and programming'),
('Science', 'Scientific discoveries and research'),
('Health', 'Health tips and medical advice'),
('Travel', 'Travel guides and experiences'),
('Food', 'Recipes and cooking tips');

-- إدخال المقالات
INSERT INTO posts (title, content, user_id) VALUES
('Introduction to Python', 'Python is a versatile programming language used in web development, data analysis, artificial intelligence, and more. Its simple syntax makes it perfect for beginners.', 2),
('The Future of AI', 'Artificial intelligence is transforming industries from healthcare to finance. Machine learning algorithms can now predict diseases and detect fraud with high accuracy.', 3),
('Healthy Eating Habits', 'Maintaining a balanced diet is essential for long-term health. Focus on whole foods, vegetables, and lean proteins while limiting processed foods and sugars.', 4),
('Best Travel Destinations for 2023', 'Here are the top destinations to visit this year including Bali, Japan, and Portugal. Each offers unique cultural experiences and breathtaking landscapes.', 5),
('Getting Started with React', 'React is a popular JavaScript library for building user interfaces. It allows developers to create reusable UI components and build single-page applications efficiently.', 2),
('Quantum Computing Explained', 'Quantum computers leverage quantum mechanics to perform complex calculations much faster than traditional computers. This technology could revolutionize cryptography and drug discovery.', 3),
('Mediterranean Diet Benefits', 'The Mediterranean diet is known for its health benefits including reduced risk of heart disease and improved brain function. It emphasizes olive oil, fish, and fresh produce.', 4),
('Hidden Gems in Italy', 'Discover less-known but beautiful places in Italy like Matera, Orvieto, and the Cinque Terre villages. These locations offer authentic Italian experiences without large crowds.', 5),
('Machine Learning Basics', 'Machine learning is a subset of AI that focuses on building systems that learn from data. Common algorithms include linear regression, decision trees, and neural networks.', 2),
('The Science of Sleep', 'Understanding how sleep affects your health and productivity. Adults need 7-9 hours of quality sleep per night for optimal cognitive function and physical health.', 3);

-- ربط المقالات بالتصنيفات
INSERT INTO post_category (post_id, category_id) VALUES
(1, 1), (2, 1), (2, 2), (3, 3), (4, 4),
(5, 1), (6, 2), (7, 3), (8, 4), (9, 1), (9, 2), (10, 2), (10, 3);

-- إدخال التعليقات
INSERT INTO comments (content, user_id, post_id) VALUES
('Great introduction! Looking forward to more Python content.', 3, 1),
('Very helpful, thanks for the clear explanation!', 4, 1),
('AI is indeed changing everything in our industry.', 2, 2),
('I tried these eating tips for a month and they really work!', 5, 3),
('Can you recommend specific places to stay in Rome?', 2, 8),
('React is my favorite frontend framework by far.', 3, 5),
('Would love more details about quantum supremacy.', 4, 6),
('Sleep is so underrated in our busy society.', 5, 10),
('Python is perfect for beginners and professionals alike.', 4, 1),
('Looking forward to your next post about AI applications!', 5, 2),
('This travel guide came at the perfect time! Planning my trip now.', 2, 4),
('How does React compare to Vue in your opinion?', 3, 5);
-- إضافة تعليق جديد
INSERT INTO comments (content, user_id, post_id)
VALUES ('new comment', 2, 2);

-- تحديث عنوان مقالة
UPDATE `posts` SET `title` = 'new title' WHERE `post_id` = 1;

-- حذف تعليق
DELETE FROM `comments` WHERE comment_id=13;

-- عدد التعليقات لكل مقالة (Grouping)
SELECT post_id,COUNT(*) AS comment_count
FROM comments GROUP BY post_id;

-- جميع المقالات مع معلومات المستخدم والتصنيفات

SELECT 
    p.post_id,
    p.title AS post_title,
    u.username AS author,
    u.email,
    c.name AS category
FROM posts p
JOIN users u ON p.user_id = u.user_id
LEFT JOIN post_category pc ON p.post_id = pc.post_id
LEFT JOIN categories c ON pc.category_id = c.category_id

ORDER BY p.post_id;
