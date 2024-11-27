<!-- views/HomeView.vue -->
<template>
    <Layout>
      <template #header>
        <h1 class="text-3xl font-bold tracking-tight text-white">Dashboard</h1>
      </template>
  
      <div class="px-4 sm:px-6 lg:px-8 pt-6">
        <div class="sm:flex sm:items-center">
          <div class="sm:flex-auto">
            <h1 class="text-base font-semibold text-gray-900">Polls</h1>
            <p class="mt-2 text-sm text-gray-700">
              A list of all currently active polls.
            </p>
          </div>
          <div class="mt-4 sm:ml-16 sm:mt-0 sm:flex-none">
            <button
              @click="$router.push('/create-proposal')"
              type="button"
              class="block rounded-md bg-indigo-600 px-3 py-2 text-center text-sm font-semibold text-white shadow-sm hover:bg-indigo-500"
            >
              Add poll
            </button>
          </div>
        </div>
  
        <div class="mt-8 flow-root">
          <div class="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
            <div class="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
              <table class="min-w-full divide-y divide-gray-300">
                <thead>
                  <tr>
                    <th
                      scope="col"
                      class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
                    >
                      User
                    </th>
                    <th
                      scope="col"
                      class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                    >
                      Title
                    </th>
                    <th
                      scope="col"
                      class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                    >
                      Status
                    </th>
                    <th
                      scope="col"
                      class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                    >
                      Type
                    </th>
                    <th
                      scope="col"
                      class="relative py-3.5 pl-3 pr-4 sm:pr-0"
                    >
                      <span class="sr-only">Edit</span>
                    </th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200 bg-white">
                  <tr v-for="person in people" :key="person.email">
                    <td
                      class="whitespace-nowrap py-5 pl-4 pr-3 text-sm sm:pl-0"
                    >
                      <div class="flex items-center">
                        <div class="h-11 w-11 shrink-0">
                          <img
                            class="h-11 w-11 rounded-full"
                            :src="person.image"
                            alt=""
                          />
                        </div>
                        <div class="ml-4">
                          <div class="font-medium text-gray-900">
                            {{ person.name }}
                          </div>
                          <div class="mt-1 text-gray-500">
                            {{ person.email }}
                          </div>
                        </div>
                      </div>
                    </td>
                    <td
                      class="whitespace-nowrap px-3 py-5 text-sm text-gray-500"
                    >
                      <div class="text-gray-900">{{ person.title }}</div>
                      <div class="mt-1 text-gray-500">
                        {{ person.department }}
                      </div>
                    </td>
                    <td
                      class="whitespace-nowrap px-3 py-5 text-sm text-gray-500"
                    >
                      <span
                        class="inline-flex items-center rounded-md bg-green-50 px-2 py-1 text-xs font-medium text-green-700 ring-1 ring-inset ring-green-600/20"
                      >
                        Active
                      </span>
                    </td>
                    <td
                      class="whitespace-nowrap px-3 py-5 text-sm text-gray-500"
                    >
                      {{ person.role }}
                    </td>
                    <td
                      class="relative whitespace-nowrap py-5 pl-3 pr-4 text-right text-sm font-medium sm:pr-0"
                    >
                      <a
                        href="#"
                        class="text-indigo-600 hover:text-indigo-900"
                      >
                        Vote<span class="sr-only">, {{ person.name }}</span>
                      </a>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </Layout>
  </template>
  
  <script setup>
  import Layout from '../components/Layout.vue';
  
  const people = [
    {
      name: 'Lindsay Walton',
      title: 'Front-end Developer',
      department: 'Optimization',
      email: 'lindsay.walton1@example.com',
      role: 'Member',
      image:
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
    },
    {
      name: 'Courtney Henry',
      title: 'Designer',
      department: 'UI/UX',
      email: 'courtney.henry@example.com',
      role: 'Member',
      image:
        'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
    },
    {
      name: 'Tom Cook',
      title: 'Director of Product',
      department: 'Management',
      email: 'tom.cook@example.com',
      role: 'Admin',
      image:
        'https://images.unsplash.com/photo-1502685104226-ee32379fefbe?auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
    },
    {
      name: 'Whitney Francis',
      title: 'Copywriter',
      department: 'Marketing',
      email: 'whitney.francis@example.com',
      role: 'Member',
      image:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
    },
    {
      name: 'Leonard Krasner',
      title: 'Senior Designer',
      department: 'Product Design',
      email: 'leonard.krasner@example.com',
      role: 'Admin',
      image:
        'https://images.unsplash.com/photo-1541101767792-f9b2b1f8d65f?auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
    },
    {
      name: 'Floyd Miles',
      title: 'Principal Designer',
      department: 'Branding',
      email: 'floyd.miles@example.com',
      role: 'Member',
      image:
        'https://images.unsplash.com/photo-1541698444083-023c97d3f4b6?auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
    },
    {
      name: 'Emily Selman',
      title: 'VP of Engineering',
      department: 'Engineering',
      email: 'emily.selman@example.com',
      role: 'Admin',
      image:
        'https://images.unsplash.com/photo-1500917293891-ef795e70e1f6?auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
    },
    {
      name: 'Kristin Watson',
      title: 'Director of Marketing',
      department: 'Marketing',
      email: 'kristin.watson@example.com',
      role: 'Member',
      image:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
    },
  ];
  </script>
  