import pandas as pd
import numpy as np
from faker import Faker
from datetime import datetime, timedelta
import random
import csv
from typing import List, Dict, Any

# Initialize Faker
fake = Faker()

# Configuration
NUM_DEPARTMENTS = 10
NUM_BRANCHES = 8
NUM_EMPLOYEES = 100
MIN_CAREER_TIMELINE_PER_EMP = 1
MAX_CAREER_TIMELINE_PER_EMP = 5

# Set random seed for reproducibility
random.seed(42)
np.random.seed(42)

# State abbreviations for USA
STATES = ['AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 
          'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD',
          'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ',
          'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC',
          'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY']

# Job levels
JOB_LEVELS = [1, 2, 3, 4, 5]
JOB_LEVEL_NAMES = {
    1: 'Junior',
    2: 'Intermediate',
    3: 'Senior',
    4: 'Lead',
    5: 'Director'
}

# Employee status codes
EMPLOYEE_STATUS = {
    0: 'Inactive',
    1: 'Active',
    2: 'On Leave',
    3: 'Terminated'
}

# Department names for a bank
DEPARTMENT_NAMES = [
    'Retail Banking', 'Commercial Banking', 'Investment Banking',
    'Wealth Management', 'Operations', 'IT Department',
    'Human Resources', 'Risk Management', 'Compliance',
    'Marketing', 'Finance', 'Audit', 'Customer Service'
]

def generate_departments(num_departments: int) -> List[Dict[str, Any]]:
    """Generate department data"""
    departments = []
    
    # First, create all departments
    for i in range(1, num_departments + 1):
        dept_name = random.choice(DEPARTMENT_NAMES)
        building_floor = f"Floor {random.randint(1, 20)}"
        budget = round(random.uniform(500000, 5000000), 6)
        
        # Parent department (some departments have parents, some don't)
        parent_dept_id = None
        if i > 3 and random.random() > 0.5:  # 50% chance of having parent
            parent_dept_id = random.randint(1, i-1)
        
        departments.append({
            'dept_id': i,
            'dept_name': dept_name,
            'building_floor': building_floor,
            'dubget_annual': budget,
            'parent_dept_id': parent_dept_id
        })
    
    return departments

def generate_employees(num_employees: int, departments: List[Dict], 
                      branches: List[Dict]) -> List[Dict[str, Any]]:
    """Generate employee data"""
    employees = []
    
    # We'll generate managers first
    managers = []
    for i in range(1, num_employees + 1):
        first_name = fake.first_name()
        last_name = fake.last_name()
        email = f"{first_name.lower()}.{last_name.lower()}@bank.com"
        
        # Generate unique phone number
        phone_number = fake.phone_number()
        if len(phone_number) > 15:
            phone_number = phone_number[:15]
        
        # Hire date in the past 10 years
        hire_date = fake.date_between(start_date='-10y', end_date='today')
        
        # Job level (weighted toward lower levels)
        job_level = random.choices(JOB_LEVELS, weights=[0.4, 0.3, 0.15, 0.1, 0.05])[0]
        
        # Salary based on job level
        base_salary = {
            1: random.randint(40000, 60000),
            2: random.randint(60000, 80000),
            3: random.randint(80000, 120000),
            4: random.randint(120000, 180000),
            5: random.randint(180000, 300000)
        }[job_level]
        
        # Add some variation
        salary = base_salary + random.randint(-5000, 5000)
        
        # Department (all departments should have at least some employees)
        dept_id = random.choice([d['dept_id'] for d in departments])
        
        # Branch
        branch_id = random.choice([b['branch_id'] for b in branches])
        
        # Manager (for now, set to NULL, we'll update later)
        manager_id = None
        
        # Status (mostly active)
        status = random.choices([0, 1, 2, 3], weights=[0.05, 0.85, 0.05, 0.05])[0]
        
        employee = {
            'emp_id': i,
            'first_name': first_name,
            'second_name': last_name,
            'email': email,
            'phone_number': phone_number,
            'hire_date': hire_date,
            'job_level': job_level,
            'salary': salary,
            'dept_id': dept_id,
            'branch_id': branch_id,
            'manager_id': manager_id,
            'status': status
        }
        
        employees.append(employee)
        
        # Track potential managers (job level 3+)
        if job_level >= 3:
            managers.append(i)
    
    # Assign managers to employees
    for i, emp in enumerate(employees):
        # Don't assign manager to top-level directors (level 5) or if no managers available
        if emp['job_level'] < 5 and managers and emp['emp_id'] not in managers:
            # Choose a manager from the same department or any manager
            potential_managers = [m for m in managers if m != emp['emp_id']]
            if potential_managers:
                emp['manager_id'] = random.choice(potential_managers)
    
    return employees, managers

def generate_branches(num_branches: int, managers: List[int]) -> List[Dict[str, Any]]:
    """Generate branch data"""
    branches = []
    
    for i in range(1, num_branches + 1):
        city = fake.city()
        state = random.choice(STATES)
        
        branch = {
            'branch_id': i,
            'branch_number': f"BR{i:04d}",
            'branch_name': f"{city} Main Branch",
            'city': city,
            'state_province': state,
            'branch_manager_id': random.choice(managers) if managers else None
        }
        branches.append(branch)
    
    return branches

def generate_career_timeline(employees: List[Dict[str, Any]], 
                            departments: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    """Generate career timeline data"""
    career_timelines = []
    history_id = 1
    
    for emp in employees:
        # Each employee has at least one career timeline entry
        num_entries = random.randint(MIN_CAREER_TIMELINE_PER_EMP, 
                                    MAX_CAREER_TIMELINE_PER_EMP)
        
        # Sort entries by date
        entry_dates = sorted([fake.date_between(
            start_date=emp['hire_date'], 
            end_date='today'
        ) for _ in range(num_entries)])
        
        current_dept = emp['dept_id']
        current_salary = emp['salary']
        current_manager = emp['manager_id']
        
        for i, entry_date in enumerate(entry_dates):
            # Reasons for change
            reasons = [
                "Promotion",
                "Department Transfer",
                "Annual Salary Review",
                "Lateral Move",
                "Performance Adjustment",
                "Market Adjustment"
            ]
            
            if i == 0:
                # First entry is hiring
                reason = "Initial Hire"
                timeline_dept = current_dept
                timeline_salary = current_salary - random.randint(5000, 15000)  # Starting salary was lower
                timeline_manager = current_manager
            else:
                reason = random.choice(reasons)
                
                # Sometimes change department
                if random.random() > 0.7:
                    timeline_dept = random.choice([d['dept_id'] for d in departments])
                else:
                    timeline_dept = current_dept
                
                # Salary changes (usually increase)
                if "Promotion" in reason or "Salary Review" in reason:
                    timeline_salary = current_salary + random.randint(5000, 20000)
                elif "Performance" in reason:
                    timeline_salary = current_salary + random.randint(1000, 5000)
                else:
                    timeline_salary = current_salary
                
                # Manager might change with department
                timeline_manager = current_manager
            
            career_timelines.append({
                'history_id': history_id,
                'emp_id': emp['emp_id'],
                'dept_id': timeline_dept,
                'manager_id': timeline_manager,
                'salary': timeline_salary,
                'effective_date': entry_date,
                'change_reason': reason
            })
            
            history_id += 1
    
    return career_timelines

def validate_data(departments: List[Dict], branches: List[Dict], 
                 employees: List[Dict], career_timelines: List[Dict]) -> None:
    """Validate data consistency"""
    print("Validating data...")
    
    # Check foreign key constraints
    emp_ids = set(emp['emp_id'] for emp in employees)
    dept_ids = set(dept['dept_id'] for dept in departments)
    branch_ids = set(branch['branch_id'] for branch in branches)
    
    # Validate employee department foreign keys
    for emp in employees:
        if emp['dept_id'] not in dept_ids:
            print(f"Warning: Employee {emp['emp_id']} has invalid dept_id {emp['dept_id']}")
        
        if emp['branch_id'] not in branch_ids:
            print(f"Warning: Employee {emp['emp_id']} has invalid branch_id {emp['branch_id']}")
        
        if emp['manager_id'] and emp['manager_id'] not in emp_ids:
            print(f"Warning: Employee {emp['emp_id']} has invalid manager_id {emp['manager_id']}")
    
    # Validate branch manager foreign keys
    for branch in branches:
        if branch['branch_manager_id'] and branch['branch_manager_id'] not in emp_ids:
            print(f"Warning: Branch {branch['branch_id']} has invalid branch_manager_id {branch['branch_manager_id']}")
    
    # Validate career timeline foreign keys
    for timeline in career_timelines:
        if timeline['emp_id'] not in emp_ids:
            print(f"Warning: Career timeline {timeline['history_id']} has invalid emp_id {timeline['emp_id']}")
        
        if timeline['dept_id'] not in dept_ids:
            print(f"Warning: Career timeline {timeline['history_id']} has invalid dept_id {timeline['dept_id']}")
        
        if timeline['manager_id'] and timeline['manager_id'] not in emp_ids:
            print(f"Warning: Career timeline {timeline['history_id']} has invalid manager_id {timeline['manager_id']}")
    
    print("Validation complete!")

def write_to_csv(filename: str, data: List[Dict[str, Any]], 
                fieldnames: List[str] = None) -> None:
    """Write data to CSV file"""
    if not data:
        print(f"No data to write for {filename}")
        return
    
    if fieldnames is None:
        fieldnames = list(data[0].keys())
    
    with open(filename, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(data)
    
    print(f"Generated {filename} with {len(data)} records")

def main():
    """Main function to generate all data"""
    print("Starting bank data generation...")
    
    # Generate data
    print("1. Generating departments...")
    departments = generate_departments(NUM_DEPARTMENTS)
    
    print("2. Generating initial employees for branch managers...")
    # We need some employees first for branch managers
    # Create a temporary branch list with placeholder manager IDs
    temp_branches = [{'branch_id': i, 'branch_manager_id': i} for i in range(1, NUM_BRANCHES + 1)]
    
    # Generate all employees at once
    employees, managers = generate_employees(NUM_EMPLOYEES, departments, temp_branches)
    
    print("3. Generating branches...")
    branches = generate_branches(NUM_BRANCHES, managers)
    
    # Update employees with actual branch manager assignments
    branch_manager_map = {b['branch_id']: b['branch_manager_id'] for b in branches}
    
    print("4. Generating career timelines...")
    career_timelines = generate_career_timeline(employees, departments)
    
    # Validate data
    validate_data(departments, branches, employees, career_timelines)
    
    # Write to CSV files
    print("\nWriting data to CSV files...")
    
    # Department CSV
    write_to_csv('department.csv', departments, 
                ['dept_id', 'dept_name', 'building_floor', 'dubget_annual', 'parent_dept_id'])
    
    # Branch CSV
    write_to_csv('branch.csv', branches,
                ['branch_id', 'branch_number', 'branch_name', 'city', 'state_province', 'branch_manager_id'])
    
    # Employee CSV
    write_to_csv('employee.csv', employees,
                ['emp_id', 'first_name', 'second_name', 'email', 'phone_number', 
                 'hire_date', 'job_level', 'salary', 'dept_id', 'branch_id', 
                 'manager_id', 'status'])
    
    # Career Timeline CSV
    write_to_csv('career_timeline.csv', career_timelines,
                ['history_id', 'emp_id', 'dept_id', 'manager_id', 'salary', 
                 'effective_date', 'change_reason'])
    
    print("\nData generation complete!")
    print(f"Generated: {len(departments)} departments")
    print(f"Generated: {len(branches)} branches")
    print(f"Generated: {len(employees)} employees")
    print(f"Generated: {len(career_timelines)} career timeline entries")
    
    # Create a summary report
    print("\n=== Data Summary ===")
    print(f"Departments: {len(departments)}")
    print(f"Branches: {len(branches)}")
    print(f"Employees: {len(employees)}")
    
    # Count employees by job level
    job_level_counts = {}
    for emp in employees:
        level = emp['job_level']
        job_level_counts[level] = job_level_counts.get(level, 0) + 1
    
    print("\nEmployees by Job Level:")
    for level in sorted(job_level_counts.keys()):
        print(f"  Level {level} ({JOB_LEVEL_NAMES.get(level, 'Unknown')}): {job_level_counts[level]}")
    
    # Count employees by status
    status_counts = {}
    for emp in employees:
        status = emp['status']
        status_counts[status] = status_counts.get(status, 0) + 1
    
    print("\nEmployees by Status:")
    for status in sorted(status_counts.keys()):
        print(f"  Status {status} ({EMPLOYEE_STATUS.get(status, 'Unknown')}): {status_counts[status]}")
    
    print("\nCSV files have been created in the current directory.")

if __name__ == "__main__":
    main()
