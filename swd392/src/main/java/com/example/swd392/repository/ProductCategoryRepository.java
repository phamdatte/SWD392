package com.example.swd392.repository;

import com.example.swd392.entity.ProductCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductCategoryRepository extends JpaRepository<ProductCategory, Long> {
    
    Optional<ProductCategory> findByCategoryName(String categoryName);
    
    List<ProductCategory> findByIsActive(Boolean isActive);
    
    boolean existsByCategoryName(String categoryName);
}
