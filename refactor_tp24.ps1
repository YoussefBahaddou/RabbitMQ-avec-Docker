$projectPath = "C:\DEV\Lechgar\DrissLechgarRepo\SeleniumScripts\downloads\TP-24 ( id 262 )\Etude-de-cas-Clients-Synchrones-RestTemplate-vs-Feign-vs-WebClient-avec-Eureka-et-Consul-main"

# Define mappings
$mappings = @(
    @{ OldDir="eureka-server"; NewDir="discovery-server"; OldPkg="com.example.eureka"; NewPkg="com.youssef.discovery"; AppName="discovery-server" },
    @{ OldDir="service-client"; NewDir="customer-service"; OldPkg="com.example.client"; NewPkg="com.youssef.customer"; AppName="customer-service" },
    @{ OldDir="service-voiture"; NewDir="car-service"; OldPkg="com.example.voiture"; NewPkg="com.youssef.car"; AppName="car-service" }
)

foreach ($map in $mappings) {
    $oldDirPath = "$projectPath\$($map.OldDir)"
    $newDirPath = "$projectPath\$($map.NewDir)"

    Write-Host "Processing $($map.AppName)..."

    # 1. Rename Directory
    if (Test-Path $oldDirPath) {
        Rename-Item -Path $oldDirPath -NewName $map.NewDir -Force
    }

    # 2. Refactor Packages
    $srcJava = "$newDirPath\src\main\java"
    $oldPkgPath = "$srcJava\$($map.OldPkg.Replace('.', '\'))"
    $newPkgPath = "$srcJava\$($map.NewPkg.Replace('.', '\'))"
    
    # Check for 'com/example' directory structure
    if (Test-Path "$srcJava\com\example") {
        New-Item -ItemType Directory -Force -Path $newPkgPath | Out-Null
        
        # Move contents
        # We need to find the specific old package dir
        $specificOldPkgDir = "$srcJava\com\example\$($map.OldDir.Replace('service-', '').Replace('server', '').Replace('eureka-', 'eureka'))" 
        # Heuristic adjustment: 
        # service-client -> com.example.client
        # service-voiture -> com.example.voiture
        # eureka-server -> com.example.eureka (usually? need to check, but assumed based on pattern)
        
        # Let's try to just move everything from com/example/* to new path? 
        # No, because inside specific modules, they correspond.
        
        Get-ChildItem "$srcJava\com\example\*" -Recurse | Move-Item -Destination $newPkgPath -Force
        
        Remove-Item "$srcJava\com\example" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item "$srcJava\com" -Recurse -Force -ErrorAction SilentlyContinue # Clean up empty com if renaming mainly
    }

    # 3. Content Replacement (Java & Config)
    $files = Get-ChildItem -Path $newDirPath -Recurse -Include "*.java", "*.xml", "*.yml", "*.properties"
    
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        
        # Package & Imports
        $content = $content -replace "package com.example.*;", "package $($map.NewPkg);"
        $content = $content -replace "package com.example.client;", "package com.youssef.customer;"
        $content = $content -replace "package com.example.voiture;", "package com.youssef.car;"
        $content = $content -replace "package com.example.eureka;", "package com.youssef.discovery;"
        
        $content = $content -replace "import com.example.client", "import com.youssef.customer"
        $content = $content -replace "import com.example.voiture", "import com.youssef.car"
        
        # POM updates
        $content = $content -replace "<groupId>com.example</groupId>", "<groupId>com.youssef</groupId>"
        $content = $content -replace "<artifactId>service-client</artifactId>", "<artifactId>customer-service</artifactId>"
        $content = $content -replace "<artifactId>service-voiture</artifactId>", "<artifactId>car-service</artifactId>"
        $content = $content -replace "<artifactId>eureka-server</artifactId>", "<artifactId>discovery-server</artifactId>"
        
        # Application Props
        $content = $content -replace "spring.application.name=.*", "spring.application.name=$($map.AppName)"
        $content = $content -replace "SERVICE-VOITURE", "car-service"
        $content = $content -replace "SERVICE-CLIENT", "customer-service"
        
        # Entity Renaming (specific to Car/Customer services)
        if ($map.AppName -eq "customer-service" -or $map.AppName -eq "car-service") {
            # Entity class renaming in content
            $content = $content -replace "public class Client", "public class Customer"
            $content = $content -replace "public class Voiture", "public class Car"
            $content = $content -replace "Client ", "Customer " 
            $content = $content -replace "Voiture ", "Car "
            $content = $content -replace "ClientRepository", "CustomerRepository"
            $content = $content -replace "VoitureRepository", "CarRepository"
            
            # Variable names
            $content = $content -replace "client", "customer"
            $content = $content -replace "voiture", "car"
            $content = $content -replace "matricule", "licensePlate"
            $content = $content -replace "marque", "brand"
            $content = $content -replace "modele", "model"
        }
        
        Set-Content -Path $file.FullName -Value $content
        
         # Rename Files
        if ($file.Name -eq "Client.java") { Rename-Item $file.FullName "Customer.java" }
        if ($file.Name -eq "Voiture.java") { Rename-Item $file.FullName "Car.java" }
        if ($file.Name -eq "ClientRepository.java") { Rename-Item $file.FullName "CustomerRepository.java" }
        if ($file.Name -eq "VoitureRepository.java") { Rename-Item $file.FullName "CarRepository.java" }
        if ($file.Name -eq "ClientController.java") { Rename-Item $file.FullName "CustomerController.java" }
        if ($file.Name -eq "VoitureController.java") { Rename-Item $file.FullName "CarController.java" }
        if ($file.Name -eq "ClientService.java") { Rename-Item $file.FullName "CustomerService.java" } # If exists
        if ($file.Name -eq "VoitureService.java") { Rename-Item $file.FullName "CarService.java" } # If exists
    }
}

# 4. Create README
$readmeContent = "# Car Rental Client System (Sync Clients)

## Overview
A microservices project demonstrating synchronous communication (RestTemplate, Feign) and Service Discovery.
Refactored by **Youssef Bahaddou**.

## Services
- **Discovery Server**: Eureka (Port 8761)
- **Customer Service**: Manages customers (Port 8088).
- **Car Service**: Manages cars (Port 8089).

## Features
- **OpenFeign**: Declarative REST Client.
- **RestTemplate**: Legacy synchronous Client.
- **Eureka**: Dynamic Service Discovery.

## Run
1. \`discovery-server\`
2. \`car-service\`
3. \`customer-service\`

## Author
Youssef Bahaddou
"
Set-Content -Path "$projectPath\README.md" -Value $readmeContent

Write-Host "TP-24 Refactoring Complete!"
