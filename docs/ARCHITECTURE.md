# EmployeesPlus System Architecture

## Overview
This document describes the architecture and workflow of the EmployeesPlus Fast Food Simulator mod.

## Component Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     EmployeesPlus Mod                       │
│                      (init.lua)                             │
└─────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    ▼                   ▼
          ┌──────────────┐      ┌──────────────┐
          │ Order System │      │  Employees   │
          └──────────────┘      └──────────────┘
                  │                     │
         ┌────────┴────────┐   ┌────────┴────────┬────────┐
         ▼                 ▼   ▼                 ▼        ▼
   ┌─────────┐      ┌──────────┐  ┌─────────┐  ┌────┐  ┌──────────┐
   │  Order  │      │ ToGoBag  │  │ FryCook │  │Cook│  │DriveThru │
   │         │      │          │  │         │  │    │  │ Cashier  │
   └─────────┘      └──────────┘  └─────────┘  └────┘  └──────────┘
```

## Class Structure

### Order
**Purpose**: Manages customer orders with unique order numbers and receipts

**Key Features**:
- Auto-incrementing order numbers (starts at 1000)
- Itemized receipt generation
- Order status tracking
- Timestamp recording

**Methods**:
- `new(items)` - Create new order
- `getOrderNumber()` - Get order number
- `getReceiptString()` - Format receipt for printing
- `setStatus(status)` - Update order status
- `getStatus()` - Get current status

### ToGoBag
**Purpose**: Represents a to-go bag that holds orders with receipts

**Key Features**:
- References order number on bag
- Attached receipt information
- Preparation status tracking
- Delivery confirmation

**Methods**:
- `new(order)` - Create new bag
- `setupWithOrder(order)` - Setup bag with order
- `attachReceipt()` - Attach receipt to bag
- `markAsPrepared()` - Mark bag as ready
- `handToCustomer()` - Complete delivery
- `getDisplayedOrderNumber()` - Get order number shown on bag

### Employee (Base Class)
**Purpose**: Base class for all employee types

**Key Features**:
- Working status management
- Task tracking
- Employee identification

**Methods**:
- `startWork()` - Start working
- `stopWork()` - Stop working
- `getIsWorking()` - Check if working
- `getCurrentTask()` - Get current task

### FryCook (extends Employee)
**Purpose**: Specialized employee for frying operations

**Key Features**:
- Manages fryer stations
- Cooks multiple items simultaneously
- Tracks cooking times per item

**Methods**:
- `assignFryerStation(stationId)` - Assign fryer
- `startFrying(item, orderNumber)` - Begin frying
- `checkCookingStatus(index)` - Check item status
- `retrieveFinishedItem(index)` - Get cooked item
- `getActiveItemCount()` - Count items being cooked

### Cook (extends Employee)
**Purpose**: General-purpose cook for food preparation

**Key Features**:
- Manages multiple cooking stations
- Handles complete orders
- Tracks item completion per order

**Methods**:
- `assignCookingStation(id, type)` - Assign station
- `startPreparingOrder(order)` - Begin order prep
- `cookItem(orderIndex, itemName)` - Cook specific item
- `completeOrder(orderIndex)` - Finish order
- `getActiveOrderCount()` - Count orders in progress

### DriveThruCashier (extends Employee)
**Purpose**: Handles drive-thru window and order delivery

**Key Features**:
- Manages drive-thru window
- **Sets up to-go bags with order numbers**
- **Attaches receipts to bags**
- Hands orders to customers
- Tracks delivery history

**Methods**:
- `assignWindow(windowId)` - Assign window
- `setupToGoBag(order)` - Create bag with order reference
- `prepareBagForPickup(bag)` - Ready bag for customer
- `handOrderToCustomer(index)` - Hand through window
- `processOrder(order)` - Complete workflow
- `getReadyOrderCount()` - Count ready orders
- `getTotalHandedOrders()` - Count delivered orders

## Workflow Diagram

### Complete Drive-Thru Order Flow

```
Customer Orders
      │
      ▼
┌─────────────┐
│ Create Order│ ← Order #1001 generated
│   (Order)   │   Receipt created
└──────┬──────┘
       │
       ▼
┌──────────────┐
│ Cook Prepares│
│    Order     │
└──────┬───────┘
       │
       ├─→ Cook Item 1 (Burger)
       ├─→ Cook Item 2 (Fries)
       └─→ Cook Item 3 (Drink)
       │
       ▼
┌──────────────┐
│Order Complete│ ← Status: "ready"
└──────┬───────┘
       │
       ▼
┌─────────────────────────┐
│  DriveThruCashier       │
│  setupToGoBag(order)    │ ← Bag references Order #1001
│                         │   Receipt attached to bag
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│ prepareBagForPickup()   │ ← Bag marked as ready
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────┐
│ handOrderToCustomer()   │ ← Handed through window
│                         │   Order #1001 delivered
└─────────────────────────┘
```

## Data Flow

### Order Creation to Delivery

```
1. Order Creation
   ┌──────────────────────────┐
   │ Items: [                 │
   │   {Burger, $5.99},       │
   │   {Fries, $2.99}         │
   │ ]                        │
   └────────────┬─────────────┘
                │
                ▼
   ┌──────────────────────────┐
   │ Order #1001              │
   │ Receipt:                 │
   │   Burger  - $5.99        │
   │   Fries   - $2.99        │
   │   Total: $8.98           │
   │ Status: "pending"        │
   └────────────┬─────────────┘

2. Preparation
                │
                ▼
   ┌──────────────────────────┐
   │ Cook.startPreparingOrder │
   │ Status: "preparing"      │
   └────────────┬─────────────┘
                │
                ▼
   ┌──────────────────────────┐
   │ Cook.cookItem("Burger")  │
   │ Cook.cookItem("Fries")   │
   └────────────┬─────────────┘
                │
                ▼
   ┌──────────────────────────┐
   │ Cook.completeOrder()     │
   │ Status: "ready"          │
   └────────────┬─────────────┘

3. Bag Setup
                │
                ▼
   ┌──────────────────────────┐
   │ ToGoBag.new(order)       │
   │ orderNumber: 1001        │
   │ receipt: {...}           │
   └────────────┬─────────────┘
                │
                ▼
   ┌──────────────────────────┐
   │ Bag marked as prepared   │
   │ Order #1001 on bag       │
   │ Receipt attached         │
   └────────────┬─────────────┘

4. Delivery
                │
                ▼
   ┌──────────────────────────┐
   │ handOrderToCustomer()    │
   │ Through drive-thru window│
   │ Status: "delivered"      │
   └──────────────────────────┘
```

## Key Features Implemented

### ✅ Fry Cook
- Manages fryer stations
- Simultaneous item cooking
- Cook time tracking
- Status monitoring

### ✅ Cook
- Multiple station management
- Complete order preparation
- Item-by-item cooking
- Order status updates

### ✅ Drive Thru Cashier
- Window assignment
- **To-go bag setup with order number reference**
- **Receipt attachment to bags**
- Customer delivery through window
- Delivery tracking and statistics

### ✅ Order System
- Unique order numbers
- Itemized receipts
- Status tracking (pending → preparing → ready → completed)
- Timestamp recording

### ✅ To-Go Bag System
- **Order number displayed on bag**
- **Receipt attached to bag**
- Preparation status
- Delivery confirmation
- Status tracking (empty → preparing → ready → delivered)

## Configuration Options

The mod supports the following configuration in `config.json`:

```json
{
  "employees": {
    "fry_cook": {
      "default_cook_time": 120,
      "max_simultaneous_items": 4
    },
    "cook": {
      "max_simultaneous_orders": 3
    },
    "drive_thru_cashier": {
      "auto_prepare_bags": true
    }
  },
  "orders": {
    "starting_order_number": 1000,
    "show_receipts": true
  },
  "to_go_bags": {
    "show_order_number": true,
    "attach_receipt": true,
    "require_preparation": true
  }
}
```

## File Organization

```
EmployeesPlus/
├── mod.json                 # Mod manifest
├── config.json              # Configuration
├── README.md                # Main documentation
├── src/
│   ├── init.lua            # Main entry point
│   ├── Order.lua           # Order management
│   ├── ToGoBag.lua         # To-go bag system
│   └── employees/
│       ├── Employee.lua    # Base class
│       ├── FryCook.lua     # Fry cook
│       ├── Cook.lua        # Cook
│       └── DriveThruCashier.lua  # Cashier
├── examples/
│   ├── example_basic.lua
│   └── example_drive_thru.lua
├── docs/
│   ├── INSTALL.md
│   ├── USAGE.md
│   └── ARCHITECTURE.md (this file)
└── tests/
    └── test_mod.lua
```

## API Summary

### Main Module (EmployeesPlus)
- `init()` - Initialize mod
- `hireEmployee(type, name)` - Hire employee
- `createOrder(items)` - Create new order
- `completeOrder(order)` - Mark order complete
- `printStatus()` - Show restaurant status

### Order API
- Create orders with items
- Generate receipts automatically
- Track order status
- Get order information

### ToGoBag API
- Setup with order reference
- Attach receipts
- Mark as prepared
- Hand to customer
- Track delivery

### Employee APIs
- Start/stop work
- Assign stations
- Process orders
- Track tasks
- Get statistics

## Best Practices

1. **Always start employees before use**: `employee:startWork()`
2. **Assign stations early**: Before processing orders
3. **Use cashier for bags**: Let DriveThruCashier handle bag setup
4. **Check status before delivery**: Verify bag is ready
5. **Complete orders**: Mark as complete after delivery

## Extension Points

The mod can be extended with:
- Additional employee types
- Custom order types
- Station management
- Inventory tracking
- Customer satisfaction
- Performance metrics
