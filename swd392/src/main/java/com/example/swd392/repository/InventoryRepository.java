package com.example.swd392.repository;

import com.example.swd392.entity.Inventory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface InventoryRepository extends JpaRepository<Inventory, Long> {
    
    Optional<Inventory> findByProduct_ProductId(Long productId);
    
    @Query("SELECT i FROM Inventory i WHERE i.quantity < :threshold")
    List<Inventory> findLowStockItems(@Param("threshold") Integer threshold);
    
    @Query("SELECT i FROM Inventory i WHERE i.quantity = 0")
    List<Inventory> findOutOfStockItems();
    
    @Query("SELECT i FROM Inventory i JOIN i.product p WHERE p.category.categoryId = :categoryId")
    List<Inventory> findByCategory(@Param("categoryId") Long categoryId);
}
