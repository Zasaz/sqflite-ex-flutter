# %%
name = 'Umair'
print('Hi ' + name);

# %%
age = 20
print('My name is ' + name + ' and i am ' + str(age) + ' years old.');

# %%
##  conditional statements
if name == "umair":
    print('Hi Umair');
else:
    print('You got the wrong guy');
# %%

print(name_is_foo = name == "Umair");

# %%
name_is_foo = name == "Umair";
print(name_is_foo);

# %%
if name == "Umair" and len(name) == 5:
    print('Hmmm that is a long name');
else:
    print('That is a short name');

# %%
is_adult = "Yes" if age > 28 else "No";
print(is_adult);

# %%
##  Functions
def add(a, b):
   return print(a + b);

# %%
add(1, 2);
# %%

add(1, 2);

# %%

def length_of_string(string_val):
    return len(string_val);

length_of_string("Umair");
# %%

print(length_of_string("Umair"));
# %%

# %%

def findId(entered_value):
    return id(entered_value);

# %%
print(findId(1));

# %%
def getFullName(firstName, lastName):
    return f"{firstName} {lastName}";

# %%
print(getFullName("Umair", "Khan"));

# %%
getFullName("Umair", "Khan")
# %%

def getFullName(firstName, lastName):
    return f"{firstName} {lastName}";

# %%
getFullName("Umair" "Khan");
# %%
def getFullName(firstName, lastName):
    return "Hello {firstName} {lastName}";

# %%
getFullName("Umair", "Khan");

# %%
def getName(firstName, lastName):
    return f"Hello {firstName} {lastName}";

# %%
getName("Umair", "Khan");
# %%
def callByName(firstName, lastName):
    return f"Hello {firstName} {lastName}";

# %%
callByName("Umair", "Khan");
# %%

def callByName(firstName, lastName):
    return f"Hello {firstName} {lastName}";

# %%
callByName(firstName="Umair", lastName="Khan");

# %%

