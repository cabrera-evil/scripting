# GitHub Scripts

This folder contains a collection of shell scripts for working with GitHub.

## Scripts

- `clone_repo.sh`: Clones a GitHub repository to the `~/git` directory.
- `create_repo.sh`: Creates a new GitHub repository.
- `delete_repo.sh`: Deletes a GitHub repository.
- `reset_repo.sh`: Rest the repository to a specific commit.
## Usage

1. Clone this repository to your local machine using the command:

    ```
    git clone https://github.com/your_username/github-scripts.git
    ```

2. Navigate to the `github-scripts` directory:

    ```
    cd github-scripts
    ```

3. Choose the script you want to use and follow its instructions.

   For example, to clone a repository using `clone_repo.sh`, run the script and follow the prompts:

    ```
    ./clone_repo.sh
    Enter repository name: myrepo
    Cloning into '/home/username/git/myrepo'...
    remote: Enumerating objects: 110, done.
    remote: Counting objects: 100% (110/110), done.
    remote: Compressing objects: 100% (80/80), done.
    remote: Total 110 (delta 35), reused 92 (delta 21), pack-reused 0
    Receiving objects: 100% (110/110), 19.21 KiB | 6.40 MiB/s, done.
    Resolving deltas: 100% (35/35), done.
    ```

   Similarly, to create or delete a repository, run `create_repo.sh` or `delete_repo.sh` respectively.

   Note that you will need to set up your GitHub API token in order to use the `create_repo.sh` and `delete_repo.sh` scripts. Please refer to the instructions in the respective scripts for more information.

That's it! Happy scripting.
