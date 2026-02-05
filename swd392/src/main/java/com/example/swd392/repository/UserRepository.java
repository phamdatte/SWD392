package com.example.swd392.repository;

import com.example.swd392.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    Optional<User> findByUsername(String username);
    
    Optional<User> findByEmail(String email);
    
    List<User> findByRole_RoleId(Long roleId);
    
    List<User> findByIsActive(Boolean isActive);
    
    boolean existsByUsername(String username);
    
    boolean existsByEmail(String email);
    
    @Query("SELECT u FROM User u WHERE u.role.roleName = :roleName AND u.isActive = true")
    List<User> findActiveUsersByRoleName(@Param("roleName") String roleName);
}
