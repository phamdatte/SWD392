-- =====================================================
-- Warehouse Management System - SIMPLIFIED VERSION
-- Chỉ tập trung: NHẬP KHO & XUẤT KHO
-- Role-Based Page Access Control
-- =====================================================

-- Drop tables if exist
DROP TABLE IF EXISTS inventory_transaction;
DROP TABLE IF EXISTS goods_issue_item;
DROP TABLE IF EXISTS goods_issue;
DROP TABLE IF EXISTS goods_receipt_item;
DROP TABLE IF EXISTS goods_receipt;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS product_category;
DROP TABLE IF EXISTS vendor;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS role_page;
DROP TABLE IF EXISTS page;
DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS config;

-- =====================================================
-- 1. CONFIG TABLE (system settings)
-- =====================================================

CREATE TABLE config (
    config_id INT PRIMARY KEY AUTO_INCREMENT,
    config_key VARCHAR(50) NOT NULL UNIQUE,
    config_value TEXT,
    description VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =====================================================
-- 2. ROLE TABLE (Vai trò)
-- =====================================================

CREATE TABLE role (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 3. PAGE TABLE (Các trang trong hệ thống)
-- =====================================================

CREATE TABLE page (
    page_id INT PRIMARY KEY AUTO_INCREMENT,
    page_code VARCHAR(50) NOT NULL UNIQUE,      -- VD: 'receipt_list', 'issue_create'
    page_name VARCHAR(100) NOT NULL,             -- Tên hiển thị
    page_url VARCHAR(200),                       -- URL/Route của page
    page_group VARCHAR(50),                      -- Nhóm: 'receipt', 'issue', 'inventory', 'admin'
    icon VARCHAR(50),                            -- Icon class (optional)
    display_order INT DEFAULT 0,                 -- Thứ tự hiển thị trong menu
    is_menu BOOLEAN DEFAULT TRUE,                -- Có hiển thị trong menu không
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 4. ROLE_PAGE TABLE (Phân quyền Role - Page)
-- =====================================================

CREATE TABLE role_page (
    role_id INT NOT NULL,
    page_id INT NOT NULL,
    can_view BOOLEAN DEFAULT TRUE,               -- Quyền xem
    can_create BOOLEAN DEFAULT FALSE,            -- Quyền tạo mới
    can_edit BOOLEAN DEFAULT FALSE,              -- Quyền sửa
    can_delete BOOLEAN DEFAULT FALSE,            -- Quyền xóa
    can_approve BOOLEEN DEFAULT FALSE,           -- Quyền duyệt
    PRIMARY KEY (role_id, page_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id),
    FOREIGN KEY (page_id) REFERENCES page(page_id)
);

-- =====================================================
-- 5. USER TABLE
-- =====================================================

CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role_id INT NOT NULL,                        -- FK to role table
    email VARCHAR(100),
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES role(role_id)
);

-- =====================================================
-- 6. VENDOR (Nhà cung cấp)
-- =====================================================

CREATE TABLE vendor (
    vendor_id INT PRIMARY KEY AUTO_INCREMENT,
    vendor_code VARCHAR(20) NOT NULL UNIQUE,
    vendor_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 4. PRODUCT CATEGORY
-- =====================================================

CREATE TABLE product_category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE
);

-- =====================================================
-- 5. PRODUCT (Sản phẩm)
-- =====================================================

CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_code VARCHAR(20) NOT NULL UNIQUE,
    barcode VARCHAR(50) UNIQUE,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    unit VARCHAR(20) NOT NULL,
    unit_price DECIMAL(15, 2) DEFAULT 0,
    category_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES product_category(category_id)
);

-- =====================================================
-- 6. INVENTORY (Tồn kho)
-- =====================================================

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL UNIQUE,
    quantity INT DEFAULT 0,
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- =====================================================
-- 7. GOODS RECEIPT (Phiếu nhập kho)
-- =====================================================

CREATE TABLE goods_receipt (
    receipt_id INT PRIMARY KEY AUTO_INCREMENT,
    receipt_number VARCHAR(20) NOT NULL UNIQUE,
    vendor_id INT NOT NULL,
    receipt_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending, Approved, Completed
    total_amount DECIMAL(15, 2) DEFAULT 0,
    notes TEXT,
    created_by INT NOT NULL,
    approved_by INT,
    approved_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id),
    FOREIGN KEY (created_by) REFERENCES user(user_id),
    FOREIGN KEY (approved_by) REFERENCES user(user_id)
);

CREATE TABLE goods_receipt_item (
    receipt_item_id INT PRIMARY KEY AUTO_INCREMENT,
    receipt_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15, 2) NOT NULL,
    subtotal DECIMAL(15, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    FOREIGN KEY (receipt_id) REFERENCES goods_receipt(receipt_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- =====================================================
-- 8. GOODS ISSUE (Phiếu xuất kho)
-- =====================================================

CREATE TABLE goods_issue (
    issue_id INT PRIMARY KEY AUTO_INCREMENT,
    issue_number VARCHAR(20) NOT NULL UNIQUE,
    customer_name VARCHAR(100),
    issue_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',  -- Pending, Approved, Completed
    total_amount DECIMAL(15, 2) DEFAULT 0,
    notes TEXT,
    created_by INT NOT NULL,
    approved_by INT,
    approved_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES user(user_id),
    FOREIGN KEY (approved_by) REFERENCES user(user_id)
);

CREATE TABLE goods_issue_item (
    issue_item_id INT PRIMARY KEY AUTO_INCREMENT,
    issue_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15, 2) NOT NULL,
    subtotal DECIMAL(15, 2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    FOREIGN KEY (issue_id) REFERENCES goods_issue(issue_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- =====================================================
-- 9. INVENTORY TRANSACTION (Lịch sử giao dịch)
-- =====================================================

CREATE TABLE inventory_transaction (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,  -- Receipt, Issue
    quantity INT NOT NULL,  -- Positive for Receipt, Negative for Issue
    quantity_before INT NOT NULL,
    quantity_after INT NOT NULL,
    reference_id INT,
    reference_type VARCHAR(20),  -- GoodsReceipt, GoodsIssue
    notes TEXT,
    performed_by INT NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (performed_by) REFERENCES user(user_id)
);

-- =====================================================
-- INSERT DEFAULT DATA
-- =====================================================

-- System Config
INSERT INTO config (config_key, config_value, description) VALUES
('system_name', 'Warehouse Management System', 'System name'),
('currency', 'VND', 'Default currency');

-- =====================================================
-- ROLES
-- =====================================================
INSERT INTO role (role_name, description) VALUES
('Admin', 'Quản trị viên - Toàn quyền'),
('Manager', 'Quản lý kho - Duyệt phiếu, xem báo cáo'),
('Staff', 'Nhân viên kho - Tạo phiếu nhập/xuất');

-- =====================================================
-- PAGES (Danh sách các trang trong hệ thống)
-- =====================================================
INSERT INTO page (page_code, page_name, page_url, page_group, icon, display_order, is_menu) VALUES
-- Dashboard
('dashboard', 'Dashboard', '/dashboard', 'dashboard', 'fa-home', 1, TRUE),

-- Nhập kho (Receipt)
('receipt_list', 'Danh sách phiếu nhập', '/receipt', 'receipt', 'fa-inbox', 10, TRUE),
('receipt_create', 'Tạo phiếu nhập', '/receipt/create', 'receipt', 'fa-plus', 11, TRUE),
('receipt_detail', 'Chi tiết phiếu nhập', '/receipt/:id', 'receipt', NULL, 12, FALSE),
('receipt_approve', 'Duyệt phiếu nhập', '/receipt/approve', 'receipt', 'fa-check', 13, TRUE),

-- Xuất kho (Issue)
('issue_list', 'Danh sách phiếu xuất', '/issue', 'issue', 'fa-share', 20, TRUE),
('issue_create', 'Tạo phiếu xuất', '/issue/create', 'issue', 'fa-plus', 21, TRUE),
('issue_detail', 'Chi tiết phiếu xuất', '/issue/:id', 'issue', NULL, 22, FALSE),
('issue_approve', 'Duyệt phiếu xuất', '/issue/approve', 'issue', 'fa-check', 23, TRUE),

-- Tồn kho (Inventory)
('inventory_list', 'Tồn kho', '/inventory', 'inventory', 'fa-boxes', 30, TRUE),
('inventory_history', 'Lịch sử giao dịch', '/inventory/history', 'inventory', 'fa-history', 31, TRUE),

-- Báo cáo (Reports)
('report_receipt', 'Báo cáo nhập kho', '/report/receipt', 'report', 'fa-chart-bar', 40, TRUE),
('report_issue', 'Báo cáo xuất kho', '/report/issue', 'report', 'fa-chart-line', 41, TRUE),
('report_inventory', 'Báo cáo tồn kho', '/report/inventory', 'report', 'fa-chart-pie', 42, TRUE),

-- Master Data
('product_list', 'Quản lý sản phẩm', '/product', 'master', 'fa-box', 50, TRUE),
('category_list', 'Quản lý danh mục', '/category', 'master', 'fa-tags', 51, TRUE),
('vendor_list', 'Quản lý nhà cung cấp', '/vendor', 'master', 'fa-truck', 52, TRUE),

-- Admin
('user_list', 'Quản lý người dùng', '/admin/user', 'admin', 'fa-users', 60, TRUE),
('role_list', 'Quản lý vai trò', '/admin/role', 'admin', 'fa-user-shield', 61, TRUE),
('page_permission', 'Phân quyền trang', '/admin/page-permission', 'admin', 'fa-lock', 62, TRUE);

-- =====================================================
-- ROLE_PAGE (Phân quyền truy cập trang theo Role)
-- =====================================================

-- Admin: Full access tất cả pages
INSERT INTO role_page (role_id, page_id, can_view, can_create, can_edit, can_delete, can_approve)
SELECT 1, page_id, TRUE, TRUE, TRUE, TRUE, TRUE FROM page;

-- Manager: Có thể duyệt, xem báo cáo, xem tồn kho
INSERT INTO role_page (role_id, page_id, can_view, can_create, can_edit, can_delete, can_approve) VALUES
-- Dashboard
(2, 1, TRUE, FALSE, FALSE, FALSE, FALSE),
-- Receipt
(2, 2, TRUE, FALSE, FALSE, FALSE, FALSE),   -- receipt_list: view only
(2, 4, TRUE, FALSE, FALSE, FALSE, FALSE),   -- receipt_detail: view only  
(2, 5, TRUE, FALSE, FALSE, FALSE, TRUE),    -- receipt_approve: view + approve
-- Issue
(2, 6, TRUE, FALSE, FALSE, FALSE, FALSE),   -- issue_list: view only
(2, 8, TRUE, FALSE, FALSE, FALSE, FALSE),   -- issue_detail: view only
(2, 9, TRUE, FALSE, FALSE, FALSE, TRUE),    -- issue_approve: view + approve
-- Inventory
(2, 10, TRUE, FALSE, FALSE, FALSE, FALSE),  -- inventory_list: view
(2, 11, TRUE, FALSE, FALSE, FALSE, FALSE),  -- inventory_history: view
-- Reports
(2, 12, TRUE, FALSE, FALSE, FALSE, FALSE),  -- report_receipt: view
(2, 13, TRUE, FALSE, FALSE, FALSE, FALSE),  -- report_issue: view
(2, 14, TRUE, FALSE, FALSE, FALSE, FALSE);  -- report_inventory: view

-- Staff: Tạo phiếu nhập/xuất, xem tồn kho
INSERT INTO role_page (role_id, page_id, can_view, can_create, can_edit, can_delete, can_approve) VALUES
-- Dashboard
(3, 1, TRUE, FALSE, FALSE, FALSE, FALSE),
-- Receipt
(3, 2, TRUE, FALSE, FALSE, FALSE, FALSE),   -- receipt_list: view
(3, 3, TRUE, TRUE, TRUE, FALSE, FALSE),     -- receipt_create: view + create + edit
(3, 4, TRUE, FALSE, TRUE, FALSE, FALSE),    -- receipt_detail: view + edit (own)
-- Issue
(3, 6, TRUE, FALSE, FALSE, FALSE, FALSE),   -- issue_list: view
(3, 7, TRUE, TRUE, TRUE, FALSE, FALSE),     -- issue_create: view + create + edit
(3, 8, TRUE, FALSE, TRUE, FALSE, FALSE),    -- issue_detail: view + edit (own)
-- Inventory
(3, 10, TRUE, FALSE, FALSE, FALSE, FALSE),  -- inventory_list: view only
(3, 11, TRUE, FALSE, FALSE, FALSE, FALSE);  -- inventory_history: view only

-- =====================================================
-- DEFAULT USERS (password: 123456)
-- =====================================================
INSERT INTO user (username, password_hash, full_name, role_id, email) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mrq4p8WY9y/FMxFZJ.g8RmlFCCHIB.a', 'Administrator', 1, 'admin@warehouse.com'),
('manager', '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mrq4p8WY9y/FMxFZJ.g8RmlFCCHIB.a', 'Warehouse Manager', 2, 'manager@warehouse.com'),
('staff', '$2a$10$N9qo8uLOickgx2ZMRZoMy.Mrq4p8WY9y/FMxFZJ.g8RmlFCCHIB.a', 'Warehouse Staff', 3, 'staff@warehouse.com');

-- Sample categories
INSERT INTO product_category (category_name, description) VALUES
('Electronics', 'Electronic devices and components'),
('Office Supplies', 'Office equipment and stationery'),
('Food & Beverage', 'Food and drink products');

-- Sample vendors
INSERT INTO vendor (vendor_code, vendor_name, contact_person, phone, email) VALUES
('V001', 'ABC Trading Co.', 'Nguyen Van A', '0901234567', 'contact@abctrading.com'),
('V002', 'XYZ Supplies Ltd.', 'Tran Thi B', '0912345678', 'info@xyzsupplies.com');

-- Sample products
INSERT INTO product (product_code, barcode, product_name, unit, unit_price, category_id) VALUES
('P001', '1234567890123', 'Laptop Dell Inspiron', 'Unit', 15000000, 1),
('P002', '1234567890124', 'Mouse Logitech', 'Unit', 250000, 1),
('P003', '1234567890125', 'A4 Paper', 'Ream', 80000, 2),
('P004', '1234567890126', 'Ballpoint Pen', 'Box', 50000, 2);

-- Initialize inventory
INSERT INTO inventory (product_id, quantity)
SELECT product_id, 0 FROM product;

-- =====================================================
-- INDEXES
-- =====================================================

CREATE INDEX idx_product_category ON product(category_id);
CREATE INDEX idx_product_barcode ON product(barcode);
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_receipt_vendor ON goods_receipt(vendor_id);
CREATE INDEX idx_receipt_status ON goods_receipt(status);
CREATE INDEX idx_receipt_date ON goods_receipt(receipt_date);
CREATE INDEX idx_issue_status ON goods_issue(status);
CREATE INDEX idx_issue_date ON goods_issue(issue_date);
CREATE INDEX idx_transaction_product ON inventory_transaction(product_id);
CREATE INDEX idx_transaction_date ON inventory_transaction(transaction_date);

-- =====================================================
-- VIEWS FOR REPORTING
-- =====================================================

-- View: Current Inventory Status
CREATE VIEW v_inventory_status AS
SELECT 
    p.product_id,
    p.product_code,
    p.barcode,
    p.product_name,
    c.category_name,
    p.unit,
    p.unit_price,
    COALESCE(i.quantity, 0) as current_quantity,
    COALESCE(i.quantity, 0) * p.unit_price as inventory_value
FROM product p
LEFT JOIN product_category c ON p.category_id = c.category_id
LEFT JOIN inventory i ON p.product_id = i.product_id
WHERE p.is_active = TRUE;

-- View: User Menu - Lấy danh sách pages mà user có quyền truy cập
CREATE VIEW v_user_menu AS
SELECT 
    u.user_id,
    u.username,
    r.role_name,
    p.page_id,
    p.page_code,
    p.page_name,
    p.page_url,
    p.page_group,
    p.icon,
    p.display_order,
    p.is_menu,
    rp.can_view,
    rp.can_create,
    rp.can_edit,
    rp.can_delete,
    rp.can_approve
FROM user u
JOIN role r ON u.role_id = r.role_id
JOIN role_page rp ON r.role_id = rp.role_id
JOIN page p ON rp.page_id = p.page_id
WHERE u.is_active = TRUE 
  AND r.is_active = TRUE 
  AND p.is_active = TRUE
  AND rp.can_view = TRUE
ORDER BY p.display_order;

-- View: Receipt Summary
CREATE VIEW v_receipt_summary AS
SELECT 
    gr.receipt_id,
    gr.receipt_number,
    gr.receipt_date,
    v.vendor_name,
    gr.status,
    gr.total_amount,
    u1.full_name as created_by_name,
    u2.full_name as approved_by_name,
    COUNT(gri.receipt_item_id) as item_count
FROM goods_receipt gr
JOIN vendor v ON gr.vendor_id = v.vendor_id
JOIN user u1 ON gr.created_by = u1.user_id
LEFT JOIN user u2 ON gr.approved_by = u2.user_id
LEFT JOIN goods_receipt_item gri ON gr.receipt_id = gri.receipt_id
GROUP BY gr.receipt_id;

-- View: Issue Summary
CREATE VIEW v_issue_summary AS
SELECT 
    gi.issue_id,
    gi.issue_number,
    gi.issue_date,
    gi.customer_name,
    gi.status,
    gi.total_amount,
    u1.full_name as created_by_name,
    u2.full_name as approved_by_name,
    COUNT(gii.issue_item_id) as item_count
FROM goods_issue gi
JOIN user u1 ON gi.created_by = u1.user_id
LEFT JOIN user u2 ON gi.approved_by = u2.user_id
LEFT JOIN goods_issue_item gii ON gi.issue_id = gii.issue_id
GROUP BY gi.issue_id;

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

DELIMITER //

-- Procedure: Approve Receipt and Update Inventory
CREATE PROCEDURE sp_approve_receipt(
    IN p_receipt_id INT,
    IN p_approved_by INT
)
BEGIN
    DECLARE v_product_id INT;
    DECLARE v_quantity INT;
    DECLARE v_current_qty INT;
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE cur CURSOR FOR 
        SELECT product_id, quantity 
        FROM goods_receipt_item 
        WHERE receipt_id = p_receipt_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Update receipt status
    UPDATE goods_receipt 
    SET status = 'Approved', 
        approved_by = p_approved_by,
        approved_at = NOW()
    WHERE receipt_id = p_receipt_id;
    
    -- Process each item
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_product_id, v_quantity;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Get current quantity
        SELECT quantity INTO v_current_qty 
        FROM inventory 
        WHERE product_id = v_product_id;
        
        -- Update inventory
        UPDATE inventory 
        SET quantity = quantity + v_quantity
        WHERE product_id = v_product_id;
        
        -- Log transaction
        INSERT INTO inventory_transaction 
            (product_id, transaction_type, quantity, quantity_before, quantity_after, 
             reference_id, reference_type, performed_by)
        VALUES 
            (v_product_id, 'Receipt', v_quantity, v_current_qty, v_current_qty + v_quantity,
             p_receipt_id, 'GoodsReceipt', p_approved_by);
    END LOOP;
    CLOSE cur;
    
    -- Update receipt to completed
    UPDATE goods_receipt 
    SET status = 'Completed'
    WHERE receipt_id = p_receipt_id;
END //

-- Procedure: Approve Issue and Update Inventory
CREATE PROCEDURE sp_approve_issue(
    IN p_issue_id INT,
    IN p_approved_by INT
)
BEGIN
    DECLARE v_product_id INT;
    DECLARE v_quantity INT;
    DECLARE v_current_qty INT;
    DECLARE done INT DEFAULT FALSE;
    
    DECLARE cur CURSOR FOR 
        SELECT product_id, quantity 
        FROM goods_issue_item 
        WHERE issue_id = p_issue_id;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Update issue status
    UPDATE goods_issue 
    SET status = 'Approved', 
        approved_by = p_approved_by,
        approved_at = NOW()
    WHERE issue_id = p_issue_id;
    
    -- Process each item
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_product_id, v_quantity;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Get current quantity
        SELECT quantity INTO v_current_qty 
        FROM inventory 
        WHERE product_id = v_product_id;
        
        -- Check if enough stock
        IF v_current_qty < v_quantity THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient inventory';
        END IF;
        
        -- Update inventory
        UPDATE inventory 
        SET quantity = quantity - v_quantity
        WHERE product_id = v_product_id;
        
        -- Log transaction
        INSERT INTO inventory_transaction 
            (product_id, transaction_type, quantity, quantity_before, quantity_after, 
             reference_id, reference_type, performed_by)
        VALUES 
            (v_product_id, 'Issue', -v_quantity, v_current_qty, v_current_qty - v_quantity,
             p_issue_id, 'GoodsIssue', p_approved_by);
    END LOOP;
    CLOSE cur;
    
    -- Update issue to completed
    UPDATE goods_issue 
    SET status = 'Completed'
    WHERE issue_id = p_issue_id;
END //

DELIMITER ;

-- =====================================================
-- END OF SCRIPT
-- =====================================================
