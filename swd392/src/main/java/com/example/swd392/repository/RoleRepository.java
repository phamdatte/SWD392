package com.example.swd392.repository;

import com.example.swd392.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {
    
    Optional<Role> findByRoleName(String roleName);
    
    List<Role> findByIsActive(Boolean isActive);
    
    boolean existsByRoleName(String roleName);
}
