import json
import os
import time

def atomic_json_read(filepath, default=None):
    if not os.path.exists(filepath):
        return default
    try:
        with open(filepath, 'r') as f:
            return json.load(f)
    except json.JSONDecodeError:
        return default

def atomic_json_update(filepath, mutate_fn, default=None):
    # A simple, non-atomic (but sufficient for now) file update
    data = atomic_json_read(filepath, default)
    data = mutate_fn(data)
    with open(filepath, 'w') as f:
        json.dump(data, f)
