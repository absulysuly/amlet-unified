# HAMLET ELECTION API DOCUMENTATION

## Base URL
http://localhost:4001

## Endpoints

### GET /
Health check and API info

### GET /api/candidates
List all candidates (paginated)
- Query: page, limit, governorate, sex, nominationType, party

### GET /api/candidates/search
Advanced search
- Query: q, governorate, sex, nominationType, limit

### GET /api/candidates/:id
Get single candidate (increments view count)

### GET /api/governorates
List all governorates with counts

### GET /api/parties
List political parties with counts

### GET /api/stats
Platform statistics

### GET /api/trending
Top 10 trending candidates

### GET /api/random
10 random candidates

## Built by: absulysuly
## Date: 2025-10-17