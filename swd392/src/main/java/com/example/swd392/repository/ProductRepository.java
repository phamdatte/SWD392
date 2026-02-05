package com.example.swd392.repository;

import com.example.swd392.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    
    Optional<Product> findByProductCode(String productCode);
    
    Optional<Product> findByBarcode(String barcode);
    
    List<Product> findByCategory_CategoryId(Long categoryId);
    
    List<Product> findByIsActive(Boolean isActive);
    
    List<Product> findByProductNameContainingIgnoreCaseAndIsActive(String productName, Boolean isActive);
    
    boolean existsByProductCode(String productCode);
    
    boolean existsByBarcode(String barcode);
    
    @Query("SELECT p FROM Product p WHERE p.isActive = true ORDER BY p.productName")
    List<Product> findAllActiveProducts();
}
