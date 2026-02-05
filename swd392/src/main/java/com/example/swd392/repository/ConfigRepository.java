package com.example.swd392.repository;

import com.example.swd392.entity.Config;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ConfigRepository extends JpaRepository<Config, Long> {
    
    Optional<Config> findByConfigKey(String configKey);
    
    boolean existsByConfigKey(String configKey);
}
